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

enum UserKind {
    case user
    case helper
    case other
}

class FirestoreHandler {
    // Handles everything to do with Firebase.
    
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = FirestoreHandler()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - User Functions
    public func addTask(with jobData: [String: Any], for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let dbRef = db.collection("tasks")

        var ref: DocumentReference? = nil
        ref = dbRef.addDocument(data: jobData) { error in
            if let error = error {
                completion(.failure(error))
            } else if let documentID = ref?.documentID {
                completion(.success(documentID))
                
                // TODO: Delete this. (also see if you can get rid of userId)
//                // Simulate assigning a helper 10 seconds after job creation
//                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                    let helperId = "imgayster"
//                    self.assignHelper(helperId, toJob: documentID, forUser: userId)
//                }
            }
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
        
        let currentUserUID = DataManager.shared.currentUserUID! // This runs after load data
        
        // Cases depending on what tasks you want to fetch.
        var dataRef = db.collection("tasks")
        
        if kind == .user {
            dataRef = db.collection("users").document(currentUserUID).collection("jobs")
        } else if kind == .helper {
            dataRef = db.collection("helpers").document(currentUserUID).collection("jobs")
        }
        
        do {
            let querySnapshot = try await dataRef.getDocuments()
            var tasks: [TaskClass] = [] // Returns array of tasks.
            
            for document in querySnapshot.documents {
                let data = document.data() // All data.
                let mediaData = try await fetchJobMedia(jobId: document.documentID) // Fetch media data
                
                // This task object is completely different from the one on firebase, it has more info.
                let task = TaskClass(
                    jobUID: document.documentID,
                    dateAdded: (data["dateAdded"] as? Timestamp)?.dateValue() ?? Date(),
                    kind: data["kind"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    dateTime: (data["dateTime"] as? Timestamp)?.dateValue() ?? Date(),
                    expectedHours: data["expectedHours"] as? Int ?? 0,
                    location: data["location"] as? String ?? "",
                    payment: data["payment"] as? Int ?? 0,
                    helperUID: data["helper"] as? String,
                    media: mediaData,
                    equipment: []
                )
                
                tasks.append(task)
            }
            
            return tasks
        } catch {
            throw error
        }
    }
    
    // MARK: - Helper Functions
    public func assignHelper(_ helperUID: String, toJob jobId: String, forUser userId: String) {
        
        let jobRef = db.collection("users").document(userId).collection("jobs").document(jobId)
        
        jobRef.updateData(["helper": helperUID]) { error in
            if let error = error {
                print("Error assigning helper: \(error.localizedDescription)")
            } else {
                // Update helper info on DataManager
                DataManager.shared.currentJobs[jobId]!.helperUID = helperUID
                return
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
    
    // MARK: - Images & Videos
    /// Uploads image to Firebase.
    ///
    /// > Warning: the ``imageUID`` is used separately for uploading video thumbnails, do not add a value here!
    ///
    /// - Parameters:
    ///     - parentFolder: the overarching parent folder for example: `"jobs"` or `"helpers"`
    ///     - containerId: the ID of the specific parent folder. Use `jobUID` when storing job data.
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
    ///     - containerId: the ID of the specific parent folder. Use `jobUID` when storing job data.
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
    /// Fetches all the media for a particular job, given a jobUID.
    ///
    /// - Parameters:
    ///     - jobId: the unique identifier of the job for which you'd like to fetch the media for.
    ///
    /// - Returns: `[PlayableMediaView]` through a completion handler. Can throw.
    func fetchJobMedia(jobId: String) async throws -> [PlayableMediaView] {
        let storageRef = Storage.storage().reference().child("jobs/\(jobId)/")
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
                return
            }
        }
    }
}
