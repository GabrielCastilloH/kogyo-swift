//
//  CurrentJobsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit
import FirebaseAuth

class CurrentJobsController: UIViewController {
    
    // MARK: - Variables
    var currentJobs: [Job] = []
    
    // MARK: - UI Components
    private let currentJobsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(CurrentJobsCell.self, forCellReuseIdentifier: CurrentJobsCell.identifier)
        return tableView
    }()
    
    private let noJobsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "You do not have any active jobs. Please go to the home screen and select a job cateogry to create a new job."
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        currentJobsTableView.delegate = self
        currentJobsTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // TODO: move this to the firebase handler.
        guard let userUID = Auth.auth().currentUser?.uid else {
            // Handle the case where the user is not authenticated
            print("User not authenticated")
            return
        }
        
        self.configureCurrentJobs(for: userUID)
    }
    
    // MARK: - UI Setup
    private func noJobsSetup() {
        self.view.addSubview(noJobsLabel)
        noJobsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noJobsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noJobsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noJobsLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Current Jobs"
    }
    
        
    private func setupUI() {
        self.view.addSubview(currentJobsTableView)
        currentJobsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentJobsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            currentJobsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            currentJobsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            currentJobsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    private func configureCurrentJobs(for userUID: String) {
        FirestoreHandler.shared.fetchJobs(for: userUID) { result in
            switch result {
            case .success(var jobs):
                jobs.sort { $0.dateAdded > $1.dateAdded } // Sorting the jobs from newest to oldest.
                
                self.currentJobs = jobs
                self.currentJobsTableView.reloadData()
                
                if self.currentJobs.count == 0 {
                    self.noJobsSetup()
                } else {
                    self.noJobsLabel.isHidden = true
                }
                
            case .failure(let error):
                print("Error fetching jobs: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Search Bar Delegate
extension CurrentJobsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.currentJobs.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentJobsCell.identifier, for: indexPath) as? CurrentJobsCell else {
            fatalError("The SearchTableView could not dequeue a SearchTableCell in HomeController.")
        }
        
        let currentJob = self.currentJobs[indexPath.row]

        cell.configureCell(for: currentJob)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobInfoController = JobInfoController(for: self.currentJobs[indexPath.row])
        
        jobInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(jobInfoController, animated: true)
    }
}
