//
//  CurrentTasksController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit
import Firebase

class CustomerMyTasksController: UIViewController {
    // Screen with all the tasks the user currently has active.
    
    // MARK: - Variables
    var currentTasks: [TaskClass] = []
    var listener: ListenerRegistration?
    
    // MARK: - UI Components
    private let currentTasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(CurrentTasksCell.self, forCellReuseIdentifier: CurrentTasksCell.identifier)
        return tableView
    }()
    
    private let noTasksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "You do not have any active tasks. Please go to the home screen and select a task cateogry to create a new task."
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.reloadTaskData()
        
        if self.currentTasks.count == 0 {
            self.noJobsSetup()
        } else {
            self.noTasksLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        currentTasksTableView.delegate = self
        currentTasksTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
        
        self.listenForCanceledTasks()
        
    }
    
    // MARK: - UI Setup
    private func noJobsSetup() {
        self.view.addSubview(noTasksLabel)
        noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noTasksLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noTasksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noTasksLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Current Jobs"
    }
    
        
    private func setupUI() {
        self.view.addSubview(currentTasksTableView)
        currentTasksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentTasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            currentTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            currentTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            currentTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    private func reloadTaskData() {
        self.currentTasks = Array(DataManager.shared.customerMyTasks.values).sorted { $0.dateAdded > $1.dateAdded }
        self.currentTasksTableView.reloadData()
    }
    private func listenForCanceledTasks() {
        let db = Firestore.firestore()
        let taskRef = db.collection("users").document(DataManager.shared.currentUser!.userUID).collection("jobs")

        
        listener = taskRef.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error listening for task updates: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No snapshot data available")
                return
            }
            
            for documentChange in querySnapshot.documentChanges {
                if documentChange.type == .removed {
                    
                    let taskUID = documentChange.document.documentID
                    let deletedTask: TaskClass = DataManager.shared.customerMyTasks[taskUID]!
                    let helper = DataManager.shared.helpers[deletedTask.helperUID!]!
                    DataManager.shared.customerMyTasks[taskUID] = nil
                    AlertManager.showCancelAlertCustomer(on: self, helper: helper, task: deletedTask)
                    self.reloadTaskData()
                }
            }
        }
    }
    
    // TODO: Finish this function
    @objc public func findAnotherHelper() {
        print("looking for more helpers lol.")
    }
}

// MARK: - Search Bar Delegate
extension CustomerMyTasksController: UITableViewDelegate, UITableViewDataSource {
    
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
        let jobId = job.taskUID
        
        let jobInfoController = CustomerTaskInfoController(for: job, jobUID: jobId)
        
        jobInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(jobInfoController, animated: true)
    }
}
