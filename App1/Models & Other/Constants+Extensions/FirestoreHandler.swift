//
//  FirestoreHandler.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirestoreHandler {
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = FirestoreHandler()
    
    private init() {}
    
    public func addJob(with job: Job, for userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
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
                
                // Simulate assigning a helper 10 seconds after job creation
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    let helperId = "Bcdo7sS8Gb3P5Kb54njO"
                    self.assignHelper(helperId, toJob: documentID, forUser: userId)
                }
            }
        }
    }
    
    func assignHelper(_ helperId: String, toJob jobId: String, forUser userId: String) {
        let db = Firestore.firestore()
        let jobRef = db.collection("users").document(userId).collection("jobs").document(jobId)
        
        jobRef.updateData(["helper": helperId]) { error in
            if let error = error {
                print("Error assigning helper: \(error.localizedDescription)")
            } else {
                print("Helper assigned successfully!")
            }
        }
    }
}
