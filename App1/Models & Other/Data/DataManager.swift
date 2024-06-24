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
    var helpers: [String: Helper] = [
        "Bcdo7sS8Gb3P5Kb54njO": Helper(
            helperUID: "Bcdo7sS8Gb3P5Kb54njO",
            firstName: "John", 
            lastName: "Doe",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ullamcorper dui in maximus pharetra. Integer faucibus massa eget nibh consequat, egestas ullamcorper purus tempor. Sed consectetur interdum dolor quis scelerisque. Suspendisse nunc augue, ultrices ut tortor eu, luctus efficitur ex. Morbi hendrerit faucibus nisi, id ultrices augue vestibulum eget. Vestibulum convallis porttitor nunc vel luctus. Nam varius, est eget iaculis accumsan, nunc ex blandit augue, vel semper ex metus non erat. Maecenas dictum condimentum ipsum. Praesent pharetra elit sed rutrum dignissim. Nunc interdum odio at mi volutpat, ut accumsan nulla consequat. Nullam ac tincidunt eros, vel sodales libero. Duis scelerisque varius interdum. Donec vitae tincidunt lacus, sit amet varius purus. Aenean scelerisque ex eu diam bibendum, rutrum posuere nulla placerat.",
            profileImage: UIImage(named: "Bcdo7sS8Gb3P5Kb54njO")!
        )
    
    ]
    
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

