//
//  DataManager.swift
//  App1
//
//  Created by Gabriel Castillo on 6/22/24.
//

import Firebase
import FirebaseAuth

class DataManager {
    // Stores all data to prevent having to reload everything.
    
    static let shared = DataManager()
    
    // USER DATA:
    var currentJobs: [String: Task] = [:]
    var userData: User?
    
    // HELPER DATA (ITS IN YOUR CLIPBOARD)
    var helperAvailableTasks: [String: Task] = [:]
    var helperMyTasks: [String: Task] = [:]
    var helpers: [String: Helper] = [:]
    
    func fetchDatabaseData(completion: @escaping () -> Void) {
        // Fetches all the data when loading Kogyo.
        
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

