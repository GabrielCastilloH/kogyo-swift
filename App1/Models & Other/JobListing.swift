//
//  JobListing.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import Foundation

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
        JobCategoryView(title: "Technology", jobButtons: [
            JobButtonView(title: "IT Support"),
            JobButtonView(title: "Electrical Work"),
            JobButtonView(title: "Wi-Fi Help"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            JobButtonView(title: "IT Support"),
            JobButtonView(title: "Electrical Work"),
            JobButtonView(title: "Wi-Fi Help"),
        ]),
    ]
    
    var allJobs: [JobButtonView] {
        // Fetching all the jobs
        var jobs: [JobButtonView] = []
        for category in allCategories {
            for job in category.jobs {
                jobs.append(job)
            }
        }
        return jobs
    }
}
