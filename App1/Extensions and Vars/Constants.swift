//
//  Constants.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

struct Constants {
    
    let darkGrayColor = UIColor(red: 0.13, green: 0.16, blue: 0.19, alpha: 1.00)
    let lightGrayColor = UIColor(red: 0.22, green: 0.24, blue: 0.27, alpha: 1.00)
    let lightBlueColor = UIColor(red: 0.00, green: 0.68, blue: 0.71, alpha: 1.00)
    let darkWhiteColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    
}

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

struct CustomFunctions {
    func createPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: Constants().lightGrayColor.withAlphaComponent(0.5)]
        )
    }
    
    func createFormLabel(for title: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = title
        return label
    }
}

extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 4)
    }
}
