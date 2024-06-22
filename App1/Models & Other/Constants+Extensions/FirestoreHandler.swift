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
    
    public func addJob(with job: Job, for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let jobsRef = db.collection("users").document(userId).collection("jobs")
        
        let jobData: [String: Any] = [
            "dateAdded": job.dateAdded,
            "kind": job.kind,
            "description": job.description,
            "dateTime": job.dateTime,
            "expectedHours": job.expectedHours,
            "location": job.location,
            "payment": job.payment,
        ]
        
        var ref: DocumentReference? = nil
        ref = jobsRef.addDocument(data: jobData) { error in
            if let error = error {
                completion(.failure(error))
            } else if let documentID = ref?.documentID {
                completion(.success(documentID))
                
                // TODO: Delete this.
                // Simulate assigning a helper 10 seconds after job creation
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    let helperId = "Bcdo7sS8Gb3P5Kb54njO"
                    self.assignHelper(helperId, toJob: documentID, forUser: userId)
                }
            }
        }
    }
    
    public func assignHelper(_ helperId: String, toJob jobId: String, forUser userId: String) {
        
        let jobRef = db.collection("users").document(userId).collection("jobs").document(jobId)
        
        jobRef.updateData(["helper": helperId]) { error in
            if let error = error {
                print("Error assigning helper: \(error.localizedDescription)")
            } else {
                return
            }
        }
    }
    
    func fetchJobs(for userId: String, completion: @escaping (Result<[Job], Error>) -> Void) {
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
                var jobs: [Job] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let job = Job(
                        jobUID: document.documentID,
                        dateAdded: (data["dateAdded"] as? Timestamp)?.dateValue() ?? Date(),
                        kind: data["kind"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        dateTime: (data["dateTime"] as? Timestamp)?.dateValue() ?? Date(),
                        expectedHours: data["expectedHours"] as? Int ?? 0,
                        location: data["location"] as? String ?? "",
                        payment: data["payment"] as? Int ?? 0,
                        helper: data["helper"] as? String
                    )
                    jobs.append(job)
                }
                completion(.success(jobs))
            }
        }
    }
    
    func fetchHelper(for helperUID: String, completion: @escaping (Result<(Helper, UIImage?), Error>) -> Void) {
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
            
            let helper = Helper(
                firstName: data["firstName"] as? String ?? "",
                lastName: data["lastName"] as? String ?? "",
                description: data["helperDescription"] as? String ?? ""
            )
            
            // Fetch profile image from Firebase Storage
            let profileRef = storageRef.child("profile/\(helperUID).jpeg")
            profileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    // If there's an error fetching the image, return the helper info without image
                    completion(.success((helper, nil)))
                    print("Error fetching image: \(error.localizedDescription)")
                } else {
                    let image = UIImage(data: data!)
                    completion(.success((helper, image)))
                }
            }
        }
    }
    
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
    
    func uploadImageToFirebase(parentFolder: String, containerId: String, image: UIImage, imageUID: String?=nil) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        var storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(UUID().uuidString).jpeg")
        
        if let imageUID = imageUID {
            storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(imageUID).jpeg")
        }
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                guard let downloadURL = url else { return }
                print("Download URL: \(downloadURL.absoluteString)")
            }
        }
    }
    
    func uploadVideoToFirebase(parentFolder: String, containerId: String, videoURL: URL, thumbnail: UIImage?) {
        let uniqueUID = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(parentFolder)/\(containerId)/\(uniqueUID).mov")
        
        self.uploadImageToFirebase(parentFolder: "jobs", containerId: "\(containerId)", image: thumbnail ?? UIImage(named: "Cleaning")!, imageUID: uniqueUID)
        
        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("Error fetching data from video URL.")
            return
        }
        
        storageRef.putData(videoData) { metadata, error in
            guard let _ = metadata, error == nil else {
                print("Error uploading data to firebase storage.")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    // TODO: Fix this.
    func fetchImageData(from item: StorageReference, completion: @escaping (UIImage?) -> Void) {
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
    
//    func fetchJobMedia(jobId: String, completion: @escaping ([PlayableMediaView]) -> Void) {
//        let storageRef = Storage.storage().reference().child("jobs/\(jobId)/")
//        var mediaData: [PlayableMediaView] = []
//        let dispatchGroup = DispatchGroup()
//        
//        storageRef.listAll { (result, error) in
//            if let error = error {
//                print("Error listing files: \(error.localizedDescription)")
//                completion(mediaData) // Complete with empty mediaData on error
//                return
//            }
//            
//            var fileNames: [String] = []
//            var videoNames: [String] = []
//            
//            for item in result!.items {
//                let name = item.name
//                let fileName = (name as NSString).deletingPathExtension
//                
//                if fileNames.contains(fileName) {
//                    videoNames.append(fileName)
//                } else {
//                    fileNames.append(fileName)
//                }
//            }
//            
//            for item in result!.items {
//                let fileName = item.name
//                let fileExtension = (fileName as NSString).pathExtension
//                
//                dispatchGroup.enter() // Enter the dispatch group
//                
//                // Determine if the file is an image or a video
//                if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
//                    if videoNames.contains(fileName) {
//                        self.fetchImageData(from: item) { image in
//                            if let image = image {
//                                let mediaView = PlayableMediaView(with: image, videoUID: fileName)
//                                mediaData.append(mediaView)
//                            }
//                            dispatchGroup.leave() // Leave the dispatch group after processing
//                        }
//                    } else {
//                        self.fetchImageData(from: item) { image in
//                            if let image = image {
//                                let mediaView = PlayableMediaView(with: image, videoUID: nil)
//                                mediaData.append(mediaView)
//                            }
//                            dispatchGroup.leave() // Leave the dispatch group after processing
//                        }
//                    }
//                    // Notify when all async operations are completed
//                    dispatchGroup.notify(queue: .main) {
//                        print("all operations were completed")
//                        completion(mediaData) // Complete with the mediaData array
//                    }
//                }
//            }
//        }
//    }
    
    
    func fetchJobMedia(jobId: String, completion: @escaping ([PlayableMediaView]) -> Void) {
        let storageRef = Storage.storage().reference().child("jobs/\(jobId)/")
        var mediaData: [PlayableMediaView] = []
        let dispatchGroup = DispatchGroup()
        
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error.localizedDescription)")
                completion(mediaData) // Complete with empty mediaData on error
                return
            }
            
            
            var fileNames: [String] = []
            var videoNames: [String] = []
            
            for item in result!.items {
                let name = item.name
                let fileName = (name as NSString).deletingPathExtension
                
                if fileNames.contains(fileName) {
                    videoNames.append(fileName)
                } else {
                    fileNames.append(fileName)
                }
            }
            
            for item in result!.items {
                let fileName = item.name
                let baseName = (fileName as NSString).deletingPathExtension
                
                let fileExtension = (fileName as NSString).pathExtension
                
                dispatchGroup.enter() // Enter the dispatch group
                
                // Determine if the file is an image or a video
                if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                    
                    // Handle image
                    item.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
                        if let error = error {
                            print("Error downloading image data: \(error.localizedDescription)")
                            dispatchGroup.leave() // Leave the dispatch group in case of error
                            return
                        }
                        
                        if let data = data, let image = UIImage(data: data) {
                            
                            var mediaView = PlayableMediaView(with: image, videoUID: nil)
                            
                            if videoNames.contains(baseName) {
                                mediaView = PlayableMediaView(with: image, videoUID: item.name)
                            }
                            
                            mediaData.append(mediaView)
                        }
                        dispatchGroup.leave() // Leave the dispatch group after processing
                    }
                } else {
                    dispatchGroup.leave() // Leave the dispatch group if file type is neither image nor video
                }
            }
            
            // Notify when all async operations are completed
            dispatchGroup.notify(queue: .main) {
                print("All operations are completed")
                completion(mediaData) // Complete with the mediaData array
            }
        }
    }
}

//
//
//
//
//// Handle image
//item.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
//    if let error = error {
//        print("Error downloading image data: \(error.localizedDescription)")
//        dispatchGroup.leave() // Leave the dispatch group in case of error
//        return
//    }
//    
//    if let data = data, let image = UIImage(data: data) {
//        let mediaView = PlayableMediaView(with: image, videoUID: nil)
//        mediaData.append(mediaView)
//    }
//    dispatchGroup.leave() // Leave the dispatch group after processing
//}
//
//} else if fileExtension == "mov" || fileExtension == "mp4" {
//print("video file")
//// Handle video | CHANGE to a thumbnail
//let mediaView = PlayableMediaView(with: UIImage(named: "Cleaning"), videoUID: fileName)
//mediaData.append(mediaView)
//
//dispatchGroup.leave() // Leave the dispatch group after processing
