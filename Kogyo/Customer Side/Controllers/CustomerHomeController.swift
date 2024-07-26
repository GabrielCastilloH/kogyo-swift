//
//  HomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class CustomerHomeController: UIViewController {
    
    // MARK: - Variables
    var taskListing = TaskListing()
    var taskSearch: [TaskCategoryBtnView] = []
    
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
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CategoriesTableCell.self, forCellReuseIdentifier: CategoriesTableCell.identifier)
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Move this to Firebase handler.
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                print("Error getting user: \(error.localizedDescription)")
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            } else if let user = user {
                self.navigationItem.title = "Welcome, \(user.firstName)"
            }
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupNavBar()
        
        self.taskSearch = taskListing.allJobs
        
        setupUI()
        setupSearchTableView()
        
        self.searchTableView.showHideView(0)

        
        // Setting the Home Screen ViewController as the delegate of the text field & table view.
        searchBar.textField.delegate = self
        searchBar.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {

        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoriesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            categoriesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            categoriesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            categoriesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Welcome."
    }
        
    private func setupSearchTableView() {
        
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
            self.taskSearch = searchText.isEmpty ? taskListing.allJobs :
                self.taskListing.allJobs.filter{$0.jobLabel.text!.lowercased().contains(searchText.lowercased())}
            searchTableView.reloadData()
        }
    }
    
    private func presentCreateJobController(for jobKind: String) {
        let createJobController = CustomerCreateTaskController(kind: jobKind)
        createJobController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(createJobController, animated: true)
    }
    
    
}

// MARK: - Search Bar Delegate
extension CustomerHomeController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTableView.showHideView(0)
        self.searchBar.cancelButton.showHideView(0)
        self.searchBar.textField.text = ""
        self.view.endEditing(true) // do this
        self.taskSearch = self.taskListing.allJobs
        self.searchTableView.reloadData()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchTableView.showHideView(1)
        self.searchBar.cancelButton.showHideView(1)
    }
}

// MARK: - Search Table & Task Table Delegate
extension CustomerHomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        if tableView == self.searchTableView {
            return self.taskSearch.count
        } else {
            return self.taskListing.allCategories.count
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier, for: indexPath) as? SearchTableCell else {
                fatalError("The SearchTableView could not dequeue a SearchTableCell in HomeController.") }

            cell.configureCell(with: self.taskSearch[indexPath.row].imageView.image!,
                               and: self.taskSearch[indexPath.row].jobLabel.text!)
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableCell.identifier, for: indexPath) as? CategoriesTableCell else {
                fatalError("The SearchTableView could not dequeue a CategoriesTableCell in HomeController.") }
            
            let category = self.taskListing.allCategories[indexPath.row]
            category.delegate = self
            
            cell.configureCell(with: category)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchTableView {
            return 80
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchTableView {
            self.presentCreateJobController(for: self.taskSearch[indexPath.row].jobLabel.text!)
        }
    }
}

// MARK: - Search Bar Delegate
extension CustomerHomeController: CustomSearchBarDelegate {
    func didClickCancel() {
        // Do the same as if the textfield should return.
        self.searchTableView.showHideView(0)
        self.searchBar.cancelButton.showHideView(0)
        self.searchBar.textField.text = ""
        self.view.endEditing(true)
        self.taskSearch = self.taskListing.allJobs
        self.searchTableView.reloadData()
    }
}

// MARK: - Task Button Delegate
extension CustomerHomeController: CategoryViewDelegate {
    func clickedButtonInCategory(kind: String) {
        self.presentCreateJobController(for: kind)
    }
}

