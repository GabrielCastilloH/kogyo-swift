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
    
    // HELPER & USER DATA
    var currentUserUID: String?
    
    // USER DATA:
    var userData: User? // TODO: Fix user data.
    var currentJobs: [String: TaskClass] = [:] // TODO: See if you change this to only a list
    var helpers: [String: Helper] = [:]
    
    // HELPER DATA
    var helperData: Helper?
    var helperAvailableTasks:[String: TaskClass] = [:]
    var helperMyTasks: [String: TaskClass] = [:]
    
    func fetchDatabaseData(asWorker: Bool = false) async {
        // Fetches all the data when loading Kogyo.
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            // TODO: make sure current user UID is accessed from data manager.
            print("User not authenticated")
            return
        }
        
        self.currentUserUID = currentUserUID
        
        if asWorker {
            do {
                // Get data for current user (in this case the helper).
                self.helperData = try await FirestoreHandler.shared.fetchHelper(for: currentUserUID)
                
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
                    print("tasskk")
                    self.helperMyTasks[task.taskUID] = task
                }
                
                print(self.helperAvailableTasks)
                
            } catch {
                print("Error fetching available tasks: \(error.localizedDescription)")
            }
            
        } else {
            
            do {
                var jobs = try await FirestoreHandler.shared.fetchTasks(.user)
                jobs.sort { $0.dateAdded > $1.dateAdded }
                
                for job in jobs {
                    self.currentJobs[job.taskUID] = job
                    
                    if let helperUID = job.helperUID {
                        do {
                            let helper = try await FirestoreHandler.shared.fetchHelper(for: helperUID)
                            self.helpers[helper.helperUID] = helper
                        } catch {
                            print("Error fetching helper: \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                print("Error fetching jobs: \(error.localizedDescription)")
            }
        }
    }
    
    func printValues() {
        print("Current Jobs: \(self.currentJobs)")
        print("Helpers: \(self.helpers)")
    }
}

