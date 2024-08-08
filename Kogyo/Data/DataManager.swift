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
    
    public var isHelper = false
    
    static let shared = DataManager()
    var deletedJobs: [TaskClass] = []
    
    // HELPER & USER DATA:
    var currentUser: User?
    
    // USER DATA:
    var customerMyTasks: [String: TaskClass] = [:]
    var customerOldTasks: [String: TaskClass] = [:]
    var helpers: [String: Helper] = [:]
    
    // HELPER DATA
    var helperData: Helper?
    var helperAvailableTasks: [String: TaskClass] = [:]
    var helperMyTasks: [String: TaskClass] = [:]
    var helperOldTasks: [String: TaskClass] = [:]
    var customers: [String: User] = [:]
    
    // MARK: - Functions
    
    /// Fetches all database data.
    ///
    /// - Parameters:
    ///     - asWorker: whether or not the data should be fetched for a helper or a customer.
    func fetchDatabaseData(asWorker: Bool = false) async {
        // Fetches all the data when loading Kogyo.
        print("started")
        do {
            let user = try await FirestoreHandler.shared.fetchCurrentUser(isHelper: self.isHelper)
            print("done fetching user")
            self.currentUser = user
            let currUID = user.userUID
            
            if asWorker {
                // Get data for current user (in this case the helper).
                self.helperData = try await FirestoreHandler.shared.fetchHelper(for: currUID)
                
                // Get data for available tasks.
                let availableTasks = try await FirestoreHandler.shared.fetchTasks(.other)
                let (notCompleteTasks, _) = availableTasks
                
                for task in notCompleteTasks.sorted(by: { $0.dateAdded > $1.dateAdded }) {
                    self.helperAvailableTasks[task.taskUID] = task
                }
                
                // Get data for tasks accepted by the helper.
                let helperTasks = try await FirestoreHandler.shared.fetchTasks(.helper)
                let (notCompleteHelperTasks, completeHelperTasks) = helperTasks
                
                for task in notCompleteHelperTasks.sorted(by: { $0.dateAdded > $1.dateAdded }) {
                    self.helperMyTasks[task.taskUID] = task
                    // Fetch the user for this task
                    let userUID = task.userUID
                    do {
                        let user = try await FirestoreHandler.shared.fetchCustomer(userUID: userUID)
                        self.customers[userUID] = user
                    } catch {
                        print("Error fetching user: \(error.localizedDescription)")
                    }
                    
                }
                
                for task in completeHelperTasks.sorted(by: { $0.dateAdded > $1.dateAdded }) {
                    self.helperOldTasks[task.taskUID] = task
                    // Ensure users are fetched for completed tasks as well
                    let userUID = task.userUID
                    do {
                        let user = try await FirestoreHandler.shared.fetchCustomer(userUID: userUID)
                        self.customers[userUID] = user
                    } catch {
                        print("Error fetching user: \(error.localizedDescription)")
                    }
                   print("should have handled this")
                }
            } else {
                // Fetch tasks for the user, both not completed and completed
                let userTasks = try await FirestoreHandler.shared.fetchTasks(.user)
                let (notCompleteUserTasks, completeUserTasks) = userTasks
                
                for job in notCompleteUserTasks.sorted(by: { $0.dateAdded > $1.dateAdded }) {
                    self.customerMyTasks[job.taskUID] = job
                    
                    // Fetch the helper for this task
                    if let helperUID = job.helperUID {
                        do {
                            let helper = try await FirestoreHandler.shared.fetchHelper(for: helperUID)
                            self.helpers[helper.helperUID] = helper
                        } catch {
                            print("Error fetching helper: \(error.localizedDescription)")
                        }
                    }
                    
                    // Fetch the user for this task
                    let userUID = job.userUID
                    do {
                        let user = try await FirestoreHandler.shared.fetchCustomer(userUID: userUID)
                        self.customers[userUID] = user
                    } catch {
                        print("Error fetching user: \(error.localizedDescription)")
                        
                    }
                }
                
                for job in completeUserTasks.sorted(by: { $0.dateAdded > $1.dateAdded }) {
                    self.customerOldTasks[job.taskUID] = job
                    
                    // Ensure helpers and users are fetched for completed tasks as well
                    if let helperUID = job.helperUID {
                        do {
                            let helper = try await FirestoreHandler.shared.fetchHelper(for: helperUID)
                            self.helpers[helper.helperUID] = helper
                        } catch {
                            print("Error fetching helper: \(error.localizedDescription)")
                        }
                    }
                    
                    let userUID = job.userUID
                    do {
                        let user = try await FirestoreHandler.shared.fetchCustomer(userUID: userUID)
                        self.customers[userUID] = user
                    } catch {
                        print("Error fetching user: \(error.localizedDescription)")
                    }
                    
                }
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        print("finished")
    }
    
    func printValues() {
        print("Current Jobs: \(self.customerMyTasks)")
        print("Old Jobs: \(self.customerOldTasks)")
        print("Helpers: \(self.helpers)")
        print("Customers: \(self.customers)")
    }
}
