//
//  HomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Variables
    var jobListing = JobListing()
    
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
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        
//        self.jobSearch = jobListing.allJobs
//        
//        setupSearchBar()
//        setupJobCategories()
//        setupSearchTableView()
//        
//        self.searchTableView.showHideView(0)
//
//        
//        // Setting the Home Screen ViewController as the delegate of the text field & table view.
//        searchBar.textField.delegate = self
//        searchBar.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//        searchTableView.delegate = self
//        searchTableView.dataSource = self
//        
//        searchBar.delegate = self
        
        self.presentCreateJobController(for: "Cleaning") // Delete this line
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - UI Setup
    private func setupSearchBar() {

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
        for (index, category) in jobListing.allCategories.enumerated() {
            
            category.delegate = self
            
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
                category.topAnchor.constraint(equalTo: jobListing.allCategories[index - 1]
                    .bottomAnchor, constant: 5)
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
    
    
    // MARK: - Selectors & Functions
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let searchText = textField.text {
            self.jobSearch = searchText.isEmpty ? jobListing.allJobs :
                self.jobListing.allJobs.filter{$0.jobLabel.text!.lowercased().contains(searchText.lowercased())}
            searchTableView.reloadData()
        }
    }
    
    private func presentCreateJobController(for jobKind: String) {
        let createJobController = CreateJobController(kind: jobKind)
        createJobController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(createJobController, animated: true)
        print(jobKind)
    }
}

// MARK: - Search Bar Delegate
extension HomeController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTableView.showHideView(0)
        self.searchBar.cancelButton.showHideView(0)
        self.searchBar.textField.text = ""
        self.view.endEditing(true) // do this
        self.jobSearch = self.jobListing.allJobs
        self.searchTableView.reloadData()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchTableView.showHideView(1)
        self.searchBar.cancelButton.showHideView(1)
    }
}

// MARK: - Search Table Delegate
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

// MARK: - Search Bar Delegate
extension HomeController: CustomSearchBarDelegate {
    func didClickCancel() {
        // Do the same as if the textfield should return.
        self.searchTableView.showHideView(0)
        self.searchBar.cancelButton.showHideView(0)
        self.searchBar.textField.text = ""
        self.view.endEditing(true)
        self.jobSearch = self.jobListing.allJobs
        self.searchTableView.reloadData()
    }
}

// MARK: - Job Button Delegate
extension HomeController: CategoryViewDelegate {
    func clickedButtonInCategory(kind: String) {
        self.presentCreateJobController(for: kind)
    }
}

