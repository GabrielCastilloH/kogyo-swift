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
    var currentJobs: [String: TaskClass] = [:]
    var userData: User?
    
    // HELPER DATA
    var helperAvailableTasks: [String: TaskClass] = [:]
    var helperMyTasks: [String: TaskClass] = [:]
    var helpers: [String: Helper] = [:]
    
    func fetchDatabaseData(asWorker: Bool = false) async {
        // Fetches all the data when loading Kogyo.
        
//        if asWorker {
//            do {
//                var availableTasks = try await FirestoreHandler.shared.fetchTasks()
//                availableTasks.sort { $0.dateAdded > $1.dateAdded }
//                
//            } catch {
//                print("Error fetching available tasks: \(error.localizedDescription)")
//            }
//            
//        } else {
            
            do {
                var jobs = try await FirestoreHandler.shared.fetchTasks(.user)
                jobs.sort { $0.dateAdded > $1.dateAdded }
                
                for job in jobs {
                    self.currentJobs[job.jobUID] = job
                    
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
//        }
    }
    
    func printValues() {
        print("Current Jobs: \(self.currentJobs)")
        print("Helpers: \(self.helpers)")
    }
}

