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
    
    // MARK: - UI Components
    let searchBar = SearchBarView()
    
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
        
        // Setting the Home Screen ViewController as the delegate of the text field.
        searchBar.textField.delegate = self
        searchBar.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
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
                category.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20)
                    .isActive = true
            } else {
                category.topAnchor.constraint(equalTo: allCategories[index - 1].bottomAnchor, constant: 5)
                    .isActive = true
            }
        }
    }
    
    // MARK: - Selectors
    @objc func textFieldDidChange(_ textField: UITextField) {
//        print(searchBar.textField.text ?? "")
    }
}

// MARK: - Update Content
extension HomeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true) // do this
        return true
    }
}

