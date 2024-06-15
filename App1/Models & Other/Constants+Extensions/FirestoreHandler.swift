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
}
