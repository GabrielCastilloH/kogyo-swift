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


// TODO: 2. Add ability to complete tasks (need to submit photo proof, must be accepted by BOTH parties).
// FOR USERS: a listener must be added to when a task is marked as complete. alerts presented as if it was deleted.
// Then: they should have the ability to review the completion and then accept it.


// TODO: 3. Add ability to see task history, completed tasks, for the user.
// TODO: 4. fix bug with fetching (or uploading videos), where the app thinks its an image. 
// TODO: 5. Make it so not all the data is loaded when the app is started, only essential data. And all media is loaded once the specific view is loaded. And once its loaded its stored, that way it doesn't have to load again!


// TODO: 4. Add chat feature between customer and helper.
// TODO: 5. Add payment feature between customer & helper (set it up with 10% comission fee later).
// TODO: 6. Setup equipment button.
// TODO: 7. Find a way to store location in firestore and calculate km away in HelperDashboard.
// TODO: 8. Setup login as helper or customer
// TODO: 9. Setup sign up as a helper (you must submit data and be approved by me), also set your work area.
// TODO: 10. Add daily, weekly and monthly earning data for helpers.
// TODO: 11. (HARD) Setup a schedule for helpers according to all the tasks they have accepted.
// TODO: 12. Setup notifications whenever a new task is posted or a task is cancelled.
// TODO: 13. Ensure anything uploaded doesn't exceed 50mb and there is a max number of images and videos. 
// TODO: 69420. Add "Hire" feature.

enum UserKind {
    case user
    case helper
    case other
}

enum DataCollection {
    case helpers
    case users
    case tasks
}

enum CompletionStatus {
    case complete
    case notComplete
    case inReview
}

enum StorageFolder {
    case completion
    case jobs
    case profile
}

class FirestoreHandler {
    // Handles everything to do with Firebase.
    
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = FirestoreHandler()
    private let db = Firestore.firestore()
    
    private init() {}
     
    // MARK: - General Functions
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
    }
    
    // MARK: - User Functions
    
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
    public func uploadTask(taskData: [String : Any], mediaData: [MediaView], completion: @escaping (Result<String, Error>) -> Void) {
        
        let dbRef = db.collection("tasks")
        var ref: DocumentReference? = nil
        
        ref = dbRef.addDocument(data: taskData) { error in
            if let error = error {
                completion(.failure(error))
            } else if let taskUID = ref?.documentID { // Once task data has been uploaded, upload all task media.
                
                let mediaArray = self.uploadMedia(taskUID: taskUID, parentFolder: .jobs, mediaData: mediaData)
                
                let newTask = CustomFunctions.shared.taskFromData(
                    for: taskUID,
                    data: taskData,
                    media: mediaArray
                )
                DataManager.shared.customerMyTasks[taskUID] = newTask
                completion(.success(taskUID))
            }
        }
    }
    
    /// Asynchronously uploads media (images and videos) associated with a task to Firebase Storage.
    ///
    /// - Parameters:
    ///   - taskUID: The unique identifier for the task to which the media belongs.
    ///   - mediaData: An array of `MediaView` objects containing the media to be uploaded.
    /// - Returns: An array of `PlayableMediaView` objects containing information about the uploaded media.
    /// - Throws: An error if any of the media uploads fail.
    func uploadMedia(taskUID: String, parentFolder: StorageFolder, mediaData: [MediaView]) -> [PlayableMediaView] {
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
                if let videoURL = media.videoURL {
                    print("uploading a video!!!!")
                    let videoUID = FirestoreHandler.shared.uploadVideoToFirebase(
                        parentFolder: containerId,
                        containerId: taskUID,
                        videoURL: videoURL,
                        thumbnail: media.mediaImageView.image
                    )
                    let playableMediaView = PlayableMediaView(with: media.media, videoUID: videoUID)
                    mediaArray.append(playableMediaView)
                } else if let imageToUpload = media.mediaImageView.image {
                    FirestoreHandler.shared.uploadImageToFirebase(
                        parentFolder: containerId,
                        containerId: taskUID,
                        image: imageToUpload
                    )
                    let playableMediaView = PlayableMediaView(with: media.media, videoUID: nil)
                    mediaArray.append(playableMediaView)
                }
            }
        }
        
        return mediaArray
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

    
    /// Fetches `[Task]` for either:  a user `userId`, a helper `helperId`, or all available tasks (both are nil).
    ///
    /// Only to be called in DataManager to set its data when the app is created.
    ///
    /// - Parameters:
    ///     - kind: An enum that is either a `user`, `helper`, or `other` (for all tasks)
    ///     - helperId?: The UID of the helper you want to fetch jobs for.
    ///     - completion: A completion handler that will return `([Task], Error)` when done.
    ///
    func fetchTasks(_ kind: UserKind) async throws -> [TaskClass] {
        
        let currentUserUID = DataManager.shared.currentUser!.userUID // Runs after data is loaded.
        
        // Cases depending on what tasks you want to fetch.
        var dataRef = db.collection("tasks")
        var query: Query? // Query for data ref.
        
        if kind == .user {
            dataRef = db.collection("users").document(currentUserUID).collection("jobs")
        } else if kind == .helper {
            query = db.collectionGroup("jobs").whereField("helperUID", isEqualTo: currentUserUID)
        }
        
        do {
            let querySnapshot = try await (query != nil ? query!.getDocuments() : dataRef.getDocuments())
            
            var tasks: [TaskClass] = [] // Returns array of tasks.
                  
            for document in querySnapshot.documents {
                let data = document.data() // All data.
                let mediaData = try await fetchJobMedia(taskId: document.documentID, parentFolder: .jobs) // Fetch media data
                
                let task = CustomFunctions.shared.taskFromData(
                    for: document.documentID,
                    data: data,
                    media: mediaData
                )
                tasks.append(task)
            }
            
            return tasks
        } catch {
            throw error
        }
    }
    
    // MARK: - Helper Functions
    public func updateTaskCompletion(userUID: String, taskUID: String, completionStatus: CompletionStatus) {
        let db = Firestore.firestore()
        let dataRef = db.collection("users").document(userUID).collection("jobs").document(taskUID)
        
        let statusString: String
        switch completionStatus {
        case .complete:
            statusString = "complete"
        case .notComplete:
            statusString = "notComplete"
        case .inReview:
            statusString = "inReview"
        }
        
        dataRef.updateData(["completionStatus": statusString]) { error in
            if let error = error {
                print("Error updating task completion status: \(error.localizedDescription)")
            } else {
                print("Task completion status successfully updated to \(statusString)")
            }
        }
    }
    
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

    
    // MARK: - Images & Videos
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
    func uploadImageToFirebase(parentFolder: String, containerId: String, image: UIImage, imageUID: String?=nil) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(UUID().uuidString).jpeg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
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
    func uploadVideoToFirebase(parentFolder: String, containerId: String, videoURL: URL, thumbnail: UIImage?) -> String? {
        let uniqueUID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(uniqueUID).mov")
        
        self.uploadImageToFirebase(parentFolder: "jobs", containerId: "\(containerId)", image: thumbnail ?? UIImage(named: "Cleaning")!, imageUID: uniqueUID)
        
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("Error fetching data from video URL.")
            return nil
        }
        
        storageRef.putData(videoData) { metadata, error in
            guard let _ = metadata, error == nil else { // metadata here if you would like to see it.
                print("Error uploading data to firebase storage.")
                return
            }
        }
        return uniqueUID
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
    
    // MARK: - Fetch Media Function
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
            
            for item in result.items {
                let fileName = item.name
                let baseName = (fileName as NSString).deletingPathExtension
                let fileExtension = (fileName as NSString).pathExtension
                
                if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                    let image = try await fetchFirebaseImage(from: item)
                    var mediaView = await PlayableMediaView(with: image, videoUID: nil)
                    
                    if videoNames.contains(baseName) {
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
