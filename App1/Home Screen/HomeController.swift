//
//  HomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Variables
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
    
    var jobSearch: [JobButtonView] = []
    
    // MARK: - UI Components
    private let searchBar = SearchBarView()
    
    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: SearchTableCell.identifier)
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.jobSearch = allJobs
        
        setupSearchBar()
        setupJobCategories()
        setupSearchTableView()
        
        self.searchTableView.showHideView(0)

        
        // Setting the Home Screen ViewController as the delegate of the text field & table view.
        searchBar.textField.delegate = self
        searchBar.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
    }
    
    // MARK: - UI Setup
    private func setupSearchBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)

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
        
    private func setupSearchTableView() {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    // MARK: - Selectors
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            self.jobSearch = searchText.isEmpty ? allJobs :
                self.allJobs.filter{$0.jobLabel.text!.lowercased().contains(searchText.lowercased())}
            searchTableView.reloadData()
        }
    }
}

// MARK: - Search Bar Delegate
extension HomeController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTableView.showHideView(0)
        self.searchBar.cancelIcon.showHideView(0)
        self.searchBar.textField.text = ""
        self.jobSearch = self.allJobs
        self.view.endEditing(true) // do this
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchTableView.showHideView(1)
        self.searchBar.cancelIcon.showHideView(1)
    }
}

// MARK: - Search Bar Delegate
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.jobSearch.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier, for: indexPath) as? SearchTableCell else {
            fatalError("The SearchTableView could not dequeue a SearchTableCell in HomeController.")
        }

        cell.configureCell(with: self.jobSearch[indexPath.row].imageView.image!,
                           and: self.jobSearch[indexPath.row].jobLabel.text!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
