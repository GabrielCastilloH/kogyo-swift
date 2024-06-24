//
//  DataManager.swift
//  App1
//
//  Created by Gabriel Castillo on 6/22/24.
//

//
//import UIKit
//import FirebaseAuth
//
//class DataManager {
//    static let shared = DataManager()
//    
//    var currentJobs: [String: Job] = [:]
//    var helpers: [String: Helper] = [:]
//    
//    func fetchDatabaseData() {
//        guard let userUID = Auth.auth().currentUser?.uid else {
//            // Handle the case where the user is not authenticated
//            print("User not authenticated")
//            return
//        }
//        
//        // Fetch all the jobs
//        FirestoreHandler.shared.fetchJobs(for: userUID) { result in
//            switch result {
//            case .success(var jobs):
//                jobs.sort { $0.dateAdded > $1.dateAdded } // Sorting the jobs from newest to oldest.
//                
//                for job in jobs {
//                    // If successful, for each job, add the job to the self.currentJobs dictionary.
//                    self.currentJobs[job.jobUID] = job
//                    
//                    // While doing that, add the helper of each job to the self.helpers dictionary.
//                    FirestoreHandler.shared.fetchHelper(for: job.helperUID!) { result in
//                        // NOTE: this optional will be nil if the user closes the app during the loading screen. To fix this: make it so that all the data is not refreshed (this function is not called) if the user is still on the loading screen. and make it so that the user can't go to the home page while they are loading a job (also prevent them from fully quiting the app).
//                        switch result {
//                        case .success(let helper):
//                            self.helpers[helper.helperUID] = helper
//                            
//                        case .failure(let error):
//                            print("Error fetching helper: \(error.localizedDescription)")
//                        }
//                    }
//                }
//                
//            case .failure(let error):
//                print("Error fetching jobs: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func printValues() {
//        print(self.currentJobs)
//        print(self.helpers)
//    }
//}

import Firebase
import FirebaseAuth

class DataManager {
    static let shared = DataManager()
    
    var currentJobs: [String: Job] = [:]
    var helpers: [String: Helper] = [:]
    
    func fetchDatabaseData(completion: @escaping () -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        FirestoreHandler.shared.fetchJobs(for: userUID) { result in
            switch result {
            case .success(var jobs):
                jobs.sort { $0.dateAdded > $1.dateAdded }
                
                for job in jobs {
                    self.currentJobs[job.jobUID] = job
                    dispatchGroup.enter()
                    FirestoreHandler.shared.fetchHelper(for: job.helperUID!) { result in
                        switch result {
                        case .success(let helper):
                            self.helpers[helper.helperUID] = helper
                        case .failure(let error):
                            print("Error fetching helper: \(error.localizedDescription)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
            case .failure(let error):
                print("Error fetching jobs: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func printValues() {
        print("Current Jobs: \(self.currentJobs)")
        print("Helpers: \(self.helpers)")
    }
}

