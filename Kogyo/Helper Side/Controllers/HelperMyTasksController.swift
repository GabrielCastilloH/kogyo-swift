//
//  HelperMyTasksController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HelperMyTasksController: UIViewController {
    // Table of all tasks accepted by a helper.
    
    // MARK: - Variables
    var myTasks: [TaskClass] = []
    private var listener: ListenerRegistration?
    
    // MARK: - UI Components
    private let myTasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HelperCurrentTasksCell.self, forCellReuseIdentifier: HelperCurrentTasksCell.identifier)
        return tableView
    }()
    
    private let noJobsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "You do not have any active tasks. Please go to you dashboard to accept tasks."
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.reloadTaskData()
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        myTasksTableView.delegate = self
        myTasksTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
        self.listenForTaskCompletions()
        
    }
    
    // MARK: - UI Setup
    private func noJobsSetup() {
        self.noJobsLabel.isHidden = false
        
        self.view.addSubview(noJobsLabel)
        noJobsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noJobsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            noJobsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noJobsLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupNavBar() {
        // Set title attributes for the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        self.navigationItem.title = "My Tasks"
        
        // Create and customize the history button
        let historyImage = UIImage(systemName: "clock.arrow.2.circlepath")?
            .withRenderingMode(.alwaysTemplate) // Use template mode for tinting
        let historyButton = UIBarButtonItem(image: historyImage, style: .plain, target: self, action: #selector(showHistory))
        
        // Customize the appearance of the button
        historyButton.tintColor = .black // Set the icon color to black
        self.navigationItem.rightBarButtonItem = historyButton
        
        // Center-align the title and the button
        self.navigationController?.navigationBar.topItem?.titleView?.tintColor = .black
    }
    
    @objc private func showHistory() {
        let oldTasksController = HelperOldTasksController()
        self.navigationController?.pushViewController(oldTasksController, animated: true)
    }

    
    
    private func setupUI() {
        self.view.addSubview(myTasksTableView)
        myTasksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myTasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            myTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            myTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            myTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    private func listenForTaskCompletions() {
        let db = Firestore.firestore()
        let taskRef = db.collection("users").document(DataManager.shared.currentUser!.userUID).collection("jobs")
        
        listener = taskRef.whereField("completionStatus", isEqualTo: "complete").addSnapshotListener { [weak self] querySnapshot, error in
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
                let document = documentChange.document
                let taskUID = document.documentID
                
                if documentChange.type == .modified {
                    if let updatedTask = DataManager.shared.helperMyTasks[taskUID] {
                        DataManager.shared.helperMyTasks[taskUID] = nil
                        DataManager.shared.helperOldTasks[taskUID] = updatedTask
                        
                        self.reloadTaskData()
                    }
                }
            }
        }
    }
    
    private func reloadTaskData() {
        self.myTasks = Array(DataManager.shared.helperMyTasks.values).sorted { $0.dateAdded > $1.dateAdded }
        self.myTasksTableView.reloadData()
        
        if self.myTasks.isEmpty {
            self.noJobsSetup()
        } else {
            self.noJobsLabel.isHidden = true
        }
    }
    
    deinit {
        listener?.remove()
    }
}

// MARK: - Search Bar Delegate
extension HelperMyTasksController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.myTasks.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelperCurrentTasksCell.identifier, for: indexPath) as? HelperCurrentTasksCell else {
            fatalError("The myTasksTableView could not dequeue a HelperCurrentTaskCell in HelperMyTasksController.")
        }
        
        let currentTask = self.myTasks[indexPath.row]
        cell.configureCell(for: currentTask)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change appearance when tapped.
        let task = self.myTasks[indexPath.row]
        let jobId = task.taskUID
        
        let taskInfoController = HelperTaskInfoController(for: task, taskUID: jobId)
        
        taskInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(taskInfoController, animated: true)
    }
}

