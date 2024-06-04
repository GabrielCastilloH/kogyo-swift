//
//  HomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class HomeController: UIViewController {
    
    
    // MARK: - UI Components
    let homeCategoryView = JobCategoryView(title: "Home")
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        self.view.addSubview(homeCategoryView)
        homeCategoryView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeCategoryView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            homeCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            homeCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            
        ])
    }
    
    
    // MARK: - Selectors
    

}

