//
//  JobListing.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import Foundation

struct TaskListing {
    
    let allCategories = [
        JobCategoryView(title: "Home", jobButtons: [
            TaskCategoryBtnView(title: "Minor Repairs"),
            TaskCategoryBtnView(title: "Cleaning"),
            TaskCategoryBtnView(title: "Painting"),
        ]),
        JobCategoryView(title: "Personal", jobButtons: [
            TaskCategoryBtnView(title: "Baby Sitting"),
            TaskCategoryBtnView(title: "Dog Walking"),
            TaskCategoryBtnView(title: "Massages"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
        JobCategoryView(title: "Technology", jobButtons: [
            TaskCategoryBtnView(title: "IT Support"),
            TaskCategoryBtnView(title: "Electrical Work"),
            TaskCategoryBtnView(title: "Wi-Fi Help"),
        ]),
    ]
    
    var allJobs: [TaskCategoryBtnView] {
        // Fetching all the jobs
        var jobs: [TaskCategoryBtnView] = []
        for category in allCategories {
            for job in category.jobs {
                jobs.append(job)
            }
        }
        return jobs
    }
}
