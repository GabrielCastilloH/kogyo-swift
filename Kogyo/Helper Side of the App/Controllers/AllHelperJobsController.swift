//
//  AllHelperJobsController.swift
//  App1
//
//  Created by Gabriel Castillo on 7/10/24.
//

import UIKit

class AllHelperJobsController: UIViewController {
    
    // MARK: - Variables
    var currentTasks: [TaskClass] = []
    
    // MARK: - UI Components
    private let currentJobsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(CurrentTasksCell.self, forCellReuseIdentifier: HelperCurrentTasksCell.identifier)
        return tableView
    }()
    
    private let noJobsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "You do not have any active tasks. Please go to the home screen and accept a task offer"
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.currentTasks = Array(DataManager.shared.currentJobs.values).sorted { $0.dateAdded > $1.dateAdded } // Add this to sort the jobs from newest to oldest, if needed.
        self.currentJobsTableView.reloadData()
        
        if self.currentTasks.count == 0 {
            self.noJobsSetup()
        } else {
            self.noJobsLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        currentJobsTableView.delegate = self
        currentJobsTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
        
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
}

// MARK: - Search Bar Delegate
extension AllHelperJobsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.currentTasks.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentTasksCell.identifier, for: indexPath) as? CurrentTasksCell else {
            fatalError("The SearchTableView could not dequeue a SearchTableCell in CustomerHomeController.")
        }
        
        let currentJob = self.currentTasks[indexPath.row]

        cell.configureCell(for: currentJob)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = self.currentTasks[indexPath.row]
        let jobId = job.jobUID
        
        let jobInfoController = JobInfoController(for: job, jobUID: jobId)
        
        jobInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(jobInfoController, animated: true)
    }
}
