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
//        "Bcdo7sS8Gb3P5Kb54njO": Helper(
//            helperUID: "Bcdo7sS8Gb3P5Kb54njO",
//            firstName: "John", 
//            lastName: "Doe",
//            description: "John Doe is a dedicated helper specializing in cleaning and painting, bringing a meticulous eye and skilled hand to every project he undertakes. With years of experience, John has honed his abilities to deliver spotless cleaning and flawless painting services, ensuring each client's home or office shines with perfection. Beyond his professional life, John is a devoted family man who enjoys spending weekends with his wife and two children, often embarking on outdoor adventures or engaging in community activities. His friendly demeanor and strong work ethic make him a favorite among clients, who appreciate not only his expertise but also the genuine care and respect he shows. Whether it’s a thorough spring clean or a vibrant new coat of paint, John brings a personal touch to his work, transforming spaces while building lasting relationships with those he serves.",
//            profileImage: UIImage(named: "Bcdo7sS8Gb3P5Kb54njO")!
//        ),
        
        "imgayster": Helper(
            helperUID: "imgayster",
            firstName: "Lyria",
            lastName: "Smith",
            description: "Lyria Smith is a compassionate and creative helper with a talent for babysitting and home decor, bringing warmth and beauty into every home she enters. With her extensive experience, Lyria has become known for her ability to create safe, nurturing environments for children while simultaneously transforming living spaces into aesthetically pleasing havens. Beyond her professional endeavors, Lyria is an avid gardener and artist, often drawing inspiration from nature and her surroundings to infuse her decor projects with unique, personal touches. She loves spending her free time painting or exploring new design trends, always eager to learn and grow. Her gentle nature and innovative spirit make her a beloved figure among her clients, who value not only her proficiency but also the genuine care she invests in her work. Whether she's caring for little ones with patience and kindness or redesigning a room to reflect a client's vision, Lyria brings a personal touch that leaves a lasting impression.",
            profileImage: UIImage(named: "imgayster")!
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

