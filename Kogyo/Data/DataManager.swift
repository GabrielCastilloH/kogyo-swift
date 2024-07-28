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
    
    // HELPER & USER DATA:
    var currentUser: User?
    
    // USER DATA:
    var currentJobs: [String: TaskClass] = [:]
    var helpers: [String: Helper] = [:]
    
    // HELPER DATA
    var helperData: Helper?
    var helperAvailableTasks:[String: TaskClass] = [:]
    var helperMyTasks: [String: TaskClass] = [:]
    
    
    // MARK: - Functions
    /// Fetches all database data.
    ///
    /// - Parameters:
    ///     - asWorker: whether or not the data should be fetched for a helper or a customer.
    func fetchDatabaseData(asWorker: Bool = false) async {
        // Fetches all the data when loading Kogyo.
        
        do {
            let user = try await FirestoreHandler.shared.fetchUser()
            self.currentUser = user
            let currUID = user.userUID
            
            if asWorker {
                // Get data for current user (in this case the helper).
                self.helperData = try await FirestoreHandler.shared.fetchHelper(for: currUID)
                
                // Get data for available tasks.
                var availableTasks = try await FirestoreHandler.shared.fetchTasks(.other)
                availableTasks.sort { $0.dateAdded > $1.dateAdded }
                for task in availableTasks {
                    self.helperAvailableTasks[task.taskUID] = task
                }
                
                // Get data for tasks accepted by the helper.
                var helperTasks = try await FirestoreHandler.shared.fetchTasks(.helper)
                helperTasks.sort { $0.dateAdded > $1.dateAdded }
                for task in helperTasks {
                    self.helperMyTasks[task.taskUID] = task
                }
            } else {
                var jobs = try await FirestoreHandler.shared.fetchTasks(.user)
                jobs.sort { $0.dateAdded > $1.dateAdded }
                for job in jobs {
                    self.currentJobs[job.taskUID] = job
                    
                    if let helperUID = job.helperUID {
                        do {
                            let helper = try await FirestoreHandler.shared.fetchHelper(for: helperUID)
                            self.helpers[helper.helperUID] = helper
                            print(helper)
                        }
                    }
                }
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func printValues() {
        print("Current Jobs: \(self.currentJobs)")
        print("Helpers: \(self.helpers)")
    }
}

