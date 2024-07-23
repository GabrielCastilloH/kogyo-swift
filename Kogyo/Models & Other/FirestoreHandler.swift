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
    
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = FirestoreHandler()
    private let db = Firestore.firestore()
    
    private init() {}
    
    public func addJob(with jobData: [String: Any], for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let jobsRef = db.collection("users").document(userId).collection("jobs")

        var ref: DocumentReference? = nil
        ref = jobsRef.addDocument(data: jobData) { error in
            if let error = error {
                completion(.failure(error))
            } else if let documentID = ref?.documentID {
                completion(.success(documentID))
                
                // TODO: Delete this.
                // Simulate assigning a helper 10 seconds after job creation
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    let helperId = "imgayster"
                    self.assignHelper(helperId, toJob: documentID, forUser: userId)
                }
            }
        }
    }
    
    /// Fetches `[Job]`object for a given `userUID`.
    ///
    /// Only to be called in DataManager to set its data when the app is created.
    ///
    /// - Parameters:
    ///     - for: The UID of the user you want to fetch jobs for.
    ///     - completion: A completion handler that will return `([Task], Error)` when done.
    ///
    func fetchJobs(for userId: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            // Handle the case where the user is not authenticated
            print("User not authenticated")
            return
        }
        
        let jobsRef = db.collection("users").document(userUID).collection("jobs")
        
        jobsRef.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var tasks: [Task] = [] // Returns array of tasks.
                
                for document in querySnapshot!.documents {
                    let data = document.data() // All data.
                    var mediaData: [PlayableMediaView] = [] // Media Data
                    
                    self.fetchJobMedia(jobId: document.documentID) { media in
                        mediaData = media
                        
                        // This task object is completely different from the one on firebase, it has more info.
                        let task = Task(
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
                        completion(.success(tasks))
                    }
                }
            }
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
    func fetchHelper(for helperUID: String, completion: @escaping (Result<Helper, Error>) -> Void) {
        
        let storageRef = Storage.storage().reference()
        
        // Fetch helper information from Firestore
        let helperRef = db.collection("helpers").document(helperUID)
        helperRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Helper not found"])
                completion(.failure(error))
                return
            }
            
            
            // Fetch profile image from Firebase Storage
            let profileRef = storageRef.child("profile/\(helperUID).jpeg")
            profileRef.getData(maxSize: 1 * 2048 * 2048) { imageData, error in
                if let error = error {
                    // If there's an error fetching the image, return the helper info without image
                    print("Error fetching image: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let profileImage = UIImage(data: imageData!)
                    
                    let helper = Helper(
                        helperUID: helperUID,
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        description: data["helperDescription"] as? String ?? "",
                        profileImage: profileImage!
                    )
                    
                    // NOTE: Completion has to be in the completion block for the profile image. (ensures not completed w/o image).
                    completion(.success(helper))
                }
            }
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
    func fetchFirebaseImage(from item: StorageReference, completion: @escaping (UIImage?) -> Void) {
        item.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading image data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
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
    func fetchJobMedia(jobId: String, completion: @escaping ([PlayableMediaView]) -> Void) {
        let storageRef = Storage.storage().reference().child("jobs/\(jobId)/")
        var mediaData: [PlayableMediaView] = []
        let dispatchGroup = DispatchGroup()
        
        // 1st: Fetch all file names.
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                completion(mediaData) // Complete with empty mediaData on error
                return
            }
            
            var fileNames: [String] = []
            var videoNames: [String] = []
            
            for item in result!.items {
                // if fileName is repeated, then that means one is a thumbnail and the other is a video.
                // NOTE: videoNames is called later.
                let name = item.name
                let fileName = (name as NSString).deletingPathExtension
                
                if fileNames.contains(fileName) {
                    videoNames.append(fileName)
                } else {
                    fileNames.append(fileName)
                }
            }
            
            // 2nd: For all file names fetch their image (or thumbnail) and create a PlayableMediaView
            for item in result!.items {
                let fileName = item.name
                let baseName = (fileName as NSString).deletingPathExtension
                
                let fileExtension = (fileName as NSString).pathExtension
                
                dispatchGroup.enter() // Enter the dispatch group
                
                // Only go through items that have jpeg (workaround problem where .mov wasn't recognized)
                if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                    
                    self.fetchFirebaseImage(from: item) { image in
                        var mediaView = PlayableMediaView(with: image, videoUID: nil)
                        
                        if videoNames.contains(baseName) {
                            mediaView = PlayableMediaView(with: image, videoUID: baseName)
                        }
                        mediaData.append(mediaView)
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave() // Leave the dispatch group if file type is neither image nor video
                }
            }
            
            // 3rd: Complete the function and return array of PlayableMediaViews
            dispatchGroup.notify(queue: .main) { // Notify when all async operations are completed
                completion(mediaData)
            }
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
