//
//  HomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Variables
    // All jobs go here:
    let allCategories = [
        JobCategoryView(title: "Home", jobButtons: [
            JobButton(title: "dud you suck"),
            JobButton(title: "dud"),
            JobButton(title: "you"),
            JobButton(title: "really suck")
        ]),
        JobCategoryView(title: "Personal", jobButtons: [
            JobButton(title: "anyways"),
            JobButton(title: "this"),
            JobButton(title: "is"),
            JobButton(title: "seriously"),
            JobButton(title: "super scalable"),
        
        ])
    ]
    // MARK: - UI Components
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        setupJobCategories()
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupJobCategories() {
        for (index, category) in allCategories.enumerated() {
            self.view.addSubview(category)
            category.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                category.heightAnchor.constraint(equalToConstant: 200),
                category.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                category.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            ])
            
            if index == 0 {
                category.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
                    .isActive = true
            } else {
                category.topAnchor.constraint(equalTo: allCategories[index - 1].bottomAnchor, constant: 20)
                    .isActive = true
            }
        }
    }
    
    
    // MARK: - Selectors
    

}

