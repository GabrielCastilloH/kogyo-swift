//
//  DataManager.swift
//  App1
//
//  Created by Gabriel Castillo on 6/22/24.
//

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
                    }
                }
                dispatchGroup.leave()
                
            case .failure(let error):
                print("Error fetching jobs: \(error.localizedDescription)")
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func printValues() {
        print("Current Jobs: \(self.currentJobs)")
        print("Helpers: \(self.helpers)")
    }
}

