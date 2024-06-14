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
    
    public func addJob(with job: Job, for userId: String, completion: @escaping(Result<Void, Error>)->Void) {
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
        
        jobsRef.addDocument(data: jobData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
