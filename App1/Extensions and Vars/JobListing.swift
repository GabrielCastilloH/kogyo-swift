//
//  JobListing.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit

struct JobListing {
    
    let allCategories = [
        JobCategoryView(title: "Home", jobButtons: [
            JobButtonView(title: "Minor Repairs"),
            JobButtonView(title: "Cleaning"),
            JobButtonView(title: "Painting"),
        ]),
        JobCategoryView(title: "Personal", jobButtons: [
            JobButtonView(title: "Baby Sitting"),
            JobButtonView(title: "Dog Walking"),
            JobButtonView(title: "Massages"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            JobButtonView(title: "IT Support"),
            JobButtonView(title: "Electrical Work"),
            JobButtonView(title: "Wi-Fi Help"),
        ]),
    ]
    
    var allJobs: [JobButtonView] {
        // Creating all jobs
        var jobs: [JobButtonView] = []
        for category in allCategories {
            for job in category.jobs {
                jobs.append(job)
            }
        }
        return jobs
    }
}

// Later you will have to work either with CoreData or Firebase (probably firebase) to save this data.
struct Job {
    let kind: String
    let description: String
    let dateTime: Date
    let expectedHours: Int
    // Change this later to a helper object
    let helperName: String
    let profileImage: UIImage?
}

struct CurrentJobs {
    var allJobs: [Job] = []
}
