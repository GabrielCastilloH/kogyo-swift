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
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CategoriesTableCell.self, forCellReuseIdentifier: CategoriesTableCell.identifier)
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = .systemPink
        self.navigationController?.navigationBar.backgroundColor = .systemPink
        self.navigationController?.navigationBar.prefersLargeTitles = false

        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            } else if let user = user {
                print("signed in: \(user.name)\n\(user.email)")
            }
        }
        
        self.jobSearch = jobListing.allJobs
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    // MARK: - UI Setup
    private func setupUI() {

        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoriesTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            categoriesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            categoriesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            categoriesTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
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
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
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
        if tableView == self.searchTableView {
            return self.jobSearch.count
        } else {
            return self.jobListing.allCategories.count
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier, for: indexPath) as? SearchTableCell else {
                fatalError("The SearchTableView could not dequeue a SearchTableCell in HomeController.") }

            cell.configureCell(with: self.jobSearch[indexPath.row].imageView.image!,
                               and: self.jobSearch[indexPath.row].jobLabel.text!)
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableCell.identifier, for: indexPath) as? CategoriesTableCell else {
                fatalError("The SearchTableView could not dequeue a CategoriesTableCell in HomeController.") }
            
            let category = self.jobListing.allCategories[indexPath.row]
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
            self.presentCreateJobController(for: self.jobSearch[indexPath.row].jobLabel.text!)
        }
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

