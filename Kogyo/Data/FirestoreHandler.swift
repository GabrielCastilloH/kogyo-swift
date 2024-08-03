//
//  FirestoreHandler.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirestoreHandler {
    // Handles everything to do with Firebase.
    
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = FirestoreHandler()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - TASK: Create
    /// Uploads a task to Firebase.
    ///
    /// ```
    /// // Data must be structured as in the function `taskFromData` #ihateduplicatedcode
    /// ```
    ///
    /// - Parameters:
    ///     - taskData: all the data for the task.
    ///
    /// - Returns: A greeting for the given `subject`.
    func uploadTask(taskData: [String : Any], mediaData: [MediaView]) async throws -> String {
        let dbRef = db.collection("tasks")
        var modifiedTaskData = taskData
        modifiedTaskData["mediaUploadComplete"] = false

        let ref: DocumentReference = try await withCheckedThrowingContinuation { continuation in
            var ref: DocumentReference? = nil
            ref = dbRef.addDocument(data: modifiedTaskData) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let ref = ref {
                    continuation.resume(returning: ref)
                } else {
                    continuation.resume(throwing: NSError(domain: "Unknown error", code: -1, userInfo: nil))
                }
            }
        }

        let taskUID = ref.documentID
        let mediaArray = await uploadMedia(taskUID: taskUID, parentFolder: .jobs, mediaData: mediaData)

        let newTask = CustomFunctions.shared.taskFromData(
            for: taskUID,
            data: taskData,
            media: mediaArray
        )
        DataManager.shared.customerMyTasks[taskUID] = newTask

        // Update the task document to set mediaUploadComplete to true
        try await dbRef.document(taskUID).updateData(["mediaUploadComplete": true])

        return taskUID
    }
    
    // MARK: - TASK: Fetch
    /// Fetches `[Task]` for either:  a user `userId`, a helper `helperId`, or all available tasks (both are nil).
    ///
    /// Only to be called in DataManager to set its data when the app is created.
    ///
    /// - Parameters:
    ///     - kind: An enum that is either a `user`, `helper`, or `other` (for all tasks)
    ///     - helperId?: The UID of the helper you want to fetch jobs for.
    ///     - completion: A completion handler that will return `([Task], Error)` when done.
    ///
    func fetchTasks(_ kind: UserKind) async throws -> ([TaskClass], [TaskClass]) {
        let currentUserUID = DataManager.shared.currentUser!.userUID
        
        var dataRef = db.collection("tasks")
        var query: Query?
        
        if kind == .user {
            dataRef = db.collection("users").document(currentUserUID).collection("jobs")
        } else if kind == .helper {
            query = db.collectionGroup("jobs").whereField("helperUID", isEqualTo: currentUserUID)
        }
        
        do {
            let querySnapshot = try await (query != nil ? query!.getDocuments() : dataRef.getDocuments())
            
            var notCompleteTasks: [TaskClass] = []
            var completeTasks: [TaskClass] = []
            
            for document in querySnapshot.documents {
                let data = document.data()
                
                let task = CustomFunctions.shared.taskFromData(
                    for: document.documentID,
                    data: data,
                    media: nil
                )
                
                if let completionStatus = data["completionStatus"] as? String {
                    if completionStatus == "complete" {
                        completeTasks.append(task)
                    } else {
                        notCompleteTasks.append(task)
                    }
                }
            }
            
            return (notCompleteTasks, completeTasks)
        } catch {
            throw error
        }
    }

    
    /// Fetches a specific `Task` for a user.
    ///
    /// - Parameters:
    ///     - taskUID: The UID of the task to fetch.
    /// - Returns: A `TaskClass` object representing the task.
    /// - Throws: An error if the task is not found or if there are issues during the fetching process.
    func fetchCustomerTask(taskUID: String) async throws -> TaskClass {
        let currentUserUID = DataManager.shared.currentUser!.userUID // Runs after data is loaded.
        let taskRef = db.collection("users").document(currentUserUID).collection("jobs").document(taskUID)
        
        do {
            let documentSnapshot = try await taskRef.getDocument()
            
            guard documentSnapshot.exists else {
                throw NSError(domain: "Task not found", code: 404, userInfo: nil)
            }
            
            let data = documentSnapshot.data() ?? [:]
            print(data)
            let mediaData = try await fetchJobMedia(taskId: documentSnapshot.documentID, parentFolder: .jobs)
            
            let task = CustomFunctions.shared.taskFromData(
                for: documentSnapshot.documentID,
                data: data,
                media: mediaData
            )
            
            return task
        } catch {
            throw error
        }
    }
    
    // MARK: - TASK: Update
    /// Updates the completion status of a task in Firestore.
    ///
    /// - Parameters:
    ///   - userUID: The unique identifier of the user.
    ///   - taskUID: The unique identifier of the task.
    ///   - completionStatus: The new completion status to be set.
    /// - Throws: An error if the Firestore update fails.
    func updateTaskCompletion(userUID: String, taskUID: String, completionStatus: CompletionStatus) async throws {
        let dataRef = db.collection("users").document(userUID).collection("jobs").document(taskUID)
        
        let status: String
        switch completionStatus {
        case .complete:
            status = "complete"
        case .notComplete:
            status = "notComplete"
        case .inReview:
            status = "inReview"
        }
        
        try await dataRef.updateData(["completionStatus": status])
        
        // Update DataManager.
    }
    
    // MARK: - TASK: Delete
    func deleteTask(taskUID: String, userUID: String, collection: DataCollection) async throws {
        let taskRef: DocumentReference
        switch collection {
        case .helpers:
            throw "No tasks under the collection: 'helpers'."
        case .users:
            taskRef = db.collection("users").document(userUID).collection("jobs").document(taskUID)
        case .tasks:
            taskRef = db.collection("tasks").document(taskUID)
        }
        
        do {
            try await taskRef.delete()
        } catch {
            print("Error deleting task: \(error)")
            throw error
        }
    }
    
    
    // MARK: - USER: Fetch
    public func fetchUser() async throws -> User {
        guard let userUID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "fetchUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }
        
        let db = Firestore.firestore()
        let document = db.collection("users").document(userUID)
        
        do {
            let snapshot = try await document.getDocument()
            
            guard let snapshotData = snapshot.data(),
                  let firstName = snapshotData["firstName"] as? String,
                  let lastName = snapshotData["lastName"] as? String,
                  let email = snapshotData["email"] as? String else {
                throw NSError(domain: "fetchUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data in snapshot"])
            }
            
            let user = User(userUID: userUID, firstName: firstName, lastName: lastName, email: email)
            return user
        } catch {
            throw error
        }
    }
    
    // MARK: - HELPER: Assign
    public func assignHelper(_ helperUID: String, toJob jobId: String, forUser userId: String, completion: @escaping (Error?) -> Void) {
        let taskRef = db.collection("tasks").document(jobId)
        let jobRef = db.collection("users").document(userId).collection("jobs").document(jobId)
        var task = DataManager.shared.helperAvailableTasks[jobId]!
        task.helperUID = helperUID
        
        taskRef.getDocument { (document, error) in
            guard let document = document, document.exists, let taskData = document.data() else {
                completion(error)
                return
            }
            
            jobRef.setData(taskData) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                taskRef.delete { error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    
                    jobRef.updateData(["helperUID": helperUID]) { error in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        DataManager.shared.helperMyTasks[jobId] = task
                        DataManager.shared.helperAvailableTasks[jobId] = nil
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: - HELPER: Fetch
    /// Fetches a `Helper`object for a given `helperUID`.
    ///
    /// It is called in FetchJobs.
    ///
    ///
    /// - Parameters:
    ///     - for: The UID of the helper you want to fetch.
    ///     - completion: A completion handler that will return `(Helper, Error)` when done.
    ///
    func fetchHelper(for helperUID: String) async throws -> Helper {
        let storageRef = Storage.storage().reference()
        
        do {
            // Fetch helper information from Firestore
            let helperRef = db.collection("helpers").document(helperUID)
            let document = try await helperRef.getDocument()
            
            guard let data = document.data() else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Helper not found"])
            }
            
            // Fetch profile image from Firebase Storage
            let profileRef = storageRef.child("profile/\(helperUID).jpeg")
            let profileImage = try await self.fetchFirebaseImage(from: profileRef)
            
            let helper = Helper(
                helperUID: helperUID,
                firstName: data["firstName"] as? String ?? "",
                lastName: data["lastName"] as? String ?? "",
                description: data["helperDescription"] as? String ?? "",
                profileImage: profileImage
            )
            
            return helper
        } catch {
            throw error
        }
    }
    
    
    // MARK: - MEDIA: Upload
    /// Uploads image to Firebase.
    ///
    /// > Warning: the ``imageUID`` is used separately for uploading video thumbnails, do not add a value here!
    ///
    /// - Parameters:
    ///     - parentFolder: the overarching parent folder for example: `"jobs"` or `"helpers"`
    ///     - containerId: the ID of the specific parent folder. Use `taskUID` when storing job data.
    ///     - image: the image you want to upload as a `UIImage`
    ///     - imageUID: do not add value. Look at warning!
    ///
    func uploadImageToFirebase(parentFolder: String, containerId: String, image: UIImage, imageUID: String? = nil) async {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let storageRef = Storage.storage().reference()
            .child("\(parentFolder)/\(containerId)/\(imageUID ?? UUID().uuidString).jpeg")
        
        do {
            _ = try await storageRef.putDataAsync(imageData)
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
        }
    }
    
    /// Uploads video to Firebase.
    ///
    /// - Parameters:
    ///     - parentFolder: the overarching parent folder for example: `"jobs"` or `"helpers"`
    ///     - containerId: the ID of the specific parent folder. Use `taskUID` when storing job data.
    ///     - videoURL: the url of the location of the video (in the users device) that you want to upload.
    ///     - thumbnail: a `UIImage` for the thumbnail of the video.
    ///
    /// - Returns: the uniqueUID of the video and the image. They are each .mov and .jpeg respectively to differentiate
    func uploadVideoToFirebase(parentFolder: String, containerId: String, videoURL: URL, thumbnail: UIImage?) async -> String? {
         let uniqueUID = UUID().uuidString
         let storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(uniqueUID).mov")
         
         await uploadImageToFirebase(parentFolder: "jobs", containerId: "\(containerId)", image: thumbnail ?? UIImage(named: "Cleaning")!, imageUID: uniqueUID)
         
         guard let videoData = try? Data(contentsOf: videoURL) else {
             print("Error fetching data from video URL.")
             return nil
         }
         
         do {
             _ = try await storageRef.putDataAsync(videoData)
         } catch {
             print("Error uploading data to firebase storage.")
             return nil
         }
         
         return uniqueUID
     }
    
    /// Asynchronously uploads media (images and videos) associated with a task to Firebase Storage.
    ///
    /// - Parameters:
    ///   - taskUID: The unique identifier for the task to which the media belongs.
    ///   - mediaData: An array of `MediaView` objects containing the media to be uploaded.
    /// - Returns: An array of `PlayableMediaView` objects containing information about the uploaded media.
    /// - Throws: An error if any of the media uploads fail.
    func uploadMedia(taskUID: String, parentFolder: StorageFolder, mediaData: [MediaView]) async -> [PlayableMediaView] {
        var mediaArray: [PlayableMediaView] = []

        let containerId: String
        switch parentFolder {
        case .completion:
            containerId = "completion"
        case .jobs:
            containerId = "jobs"
        case .profile:
            containerId = "profile"
        }

        for media in mediaData {
            if media != mediaData.first {
                if let videoURL = await media.videoURL {
                    print("uploading a video!!!!")
                    let videoUID = await FirestoreHandler.shared.uploadVideoToFirebase(
                        parentFolder: containerId,
                        containerId: taskUID,
                        videoURL: videoURL,
                        thumbnail: media.mediaImageView.image
                    )
                    let playableMediaView = await PlayableMediaView(with: media.media, videoUID: videoUID)
                    mediaArray.append(playableMediaView)
                } else if let imageToUpload = await media.mediaImageView.image {
                    await FirestoreHandler.shared.uploadImageToFirebase(
                        parentFolder: containerId,
                        containerId: taskUID,
                        image: imageToUpload
                    )
                    let playableMediaView = await PlayableMediaView(with: media.media, videoUID: nil)
                    mediaArray.append(playableMediaView)
                }
            }
        }
        return mediaArray
    }
    
    // MARK: - MEDIA: Fetch
    /// Fetches all the media for a particular job, given a taskUID.
    ///
    /// - Parameters:
    ///     - jobId: the unique identifier of the job for which you'd like to fetch the media for.
    ///
    /// - Returns: `[PlayableMediaView]` through a completion handler. Can throw.
    func fetchJobMedia(taskId: String, parentFolder: StorageFolder) async throws -> [PlayableMediaView] {
        let containerId: String
        switch parentFolder {
        case .completion:
            containerId = "completion"
        case .jobs:
            containerId = "jobs"
        case .profile:
            containerId = "profile"
        }
        
        let storageRef = Storage.storage().reference().child("\(containerId)/\(taskId)/")
        var mediaData: [PlayableMediaView] = []
        
        do {
            let result = try await storageRef.listAll()
            
            var fileNames: [String] = []
            var videoNames: [String] = []
            
            for item in result.items {
                let name = item.name
                let fileName = (name as NSString).deletingPathExtension
                
                if fileNames.contains(fileName) {
                    videoNames.append(fileName)
                } else {
                    fileNames.append(fileName)
                }
            }
            
            print("videosnames:", videoNames)
            
            for item in result.items {
                let fileName = item.name
                let baseName = (fileName as NSString).deletingPathExtension
                let fileExtension = (fileName as NSString).pathExtension
                
                if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                    let image = try await fetchFirebaseImage(from: item)
                    var mediaView = await PlayableMediaView(with: image, videoUID: nil)
                    
                    if videoNames.contains(baseName) {
                        print("getting video")
                        mediaView = await PlayableMediaView(with: image, videoUID: baseName)
                    }
                    mediaData.append(mediaView)
                }
            }
            
            return mediaData
        } catch {
            print("Error listing files: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Fetches an image from Firebase storage given a `StorageReference`
    ///
    /// - Parameters:
    ///     - from: `StorageReference` where image is held.
    ///
    /// - Returns: A greeting for the given `subject`.
    func fetchFirebaseImage(from item: StorageReference) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            item.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image data: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let data = data, let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: NSError(domain: "Image data error", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // MARK: - MEDIA: Delete
    /// Deletes all media files associated with a specific task from Firebase storage.
    ///
    /// This function deletes all media files (such as images and videos) stored under a specified
    /// task ID and parent folder in Firebase storage.
    ///
    /// - Parameters:
    ///   - taskId: A unique identifier for the task whose media files are to be deleted.
    ///   - parentFolder: The parent folder under which the media files are stored. This can be
    ///     one of `.completion`, `.jobs`, or `.profile`.
    ///
    /// - Throws: An error if there is an issue listing or deleting the files in Firebase storage.
    ///
    func deleteMedia(taskId: String, parentFolder: StorageFolder) async throws {
        let containerId: String
        switch parentFolder {
        case .completion:
            containerId = "completion"
        case .jobs:
            containerId = "jobs"
        case .profile:
            containerId = "profile"
        }
        
        let storageRef = Storage.storage().reference().child("\(containerId)/\(taskId)/")
        
        do {
            let result = try await storageRef.listAll()
            
            for item in result.items {
                try await item.delete()
            }
            
            print("All media files for task \(taskId) in \(containerId) have been deleted.")
        } catch {
            print("Error deleting files: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Other Functions
    public func editNames(userUID: String, firstName: String, lastName: String) {
        
        let userRef = db.collection("users").document(userUID)
        
        userRef.updateData([
            "firstName": firstName,
            "lastName": lastName
        ]) { error in
            if let error = error {
                print("Error updating names: \(error.localizedDescription)")
            } else {
                // Update data manager.
                DataManager.shared.currentUser?.firstName = firstName
                DataManager.shared.currentUser?.lastName = lastName
                
                return
            }
        }
    }
}
