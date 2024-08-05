//
//  HelperOldTasksController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/2/24.
//

import UIKit

class HelperOldTasksController: UIViewController {
    // Screen with all the tasks the helper has completed in the past.
    
    // MARK: - Variables
    var oldTasks: [TaskClass] = []
    
    // MARK: - UI Components
    private let oldTasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(HelperCurrentTasksCell.self, forCellReuseIdentifier: HelperCurrentTasksCell.identifier)
        return tableView
    }()
    
    private let noTasksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "You do not have any completed tasks. Please check back later or visit your dashboard for more details."
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.reloadTaskData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        oldTasksTableView.delegate = self
        oldTasksTableView.dataSource = self
        
        self.setupNavBar()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func noTasksSetup() {
        if !self.view.contains(noTasksLabel) {
            self.view.addSubview(noTasksLabel)
            noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                noTasksLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                noTasksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                noTasksLabel.widthAnchor.constraint(equalToConstant: 250),
            ])
        }
        
        self.noTasksLabel.isHidden = false
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Old Tasks"
    }
    
    private func setupUI() {
        self.view.addSubview(oldTasksTableView)
        oldTasksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            oldTasksTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            oldTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            oldTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            oldTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    private func reloadTaskData() {
        self.oldTasks = Array(DataManager.shared.helperOldTasks.values).sorted { $0.dateAdded > $1.dateAdded }
        self.oldTasksTableView.reloadData()
        
        if self.oldTasks.isEmpty {
            self.noTasksSetup()
        } else {
            self.noTasksLabel.isHidden = true
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension HelperOldTasksController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oldTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelperCurrentTasksCell.identifier, for: indexPath) as? HelperCurrentTasksCell else {
            fatalError("The oldTasksTableView could not dequeue a HelperCurrentTasksCell in HelperOldTasksController.")
        }
        
        let oldTask = self.oldTasks[indexPath.row]
        cell.configureCell(for: oldTask)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.oldTasks[indexPath.row]
        let taskId = task.taskUID
        
        let taskInfoController = HelperTaskInfoController(for: task, taskUID: taskId)
        
        taskInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(taskInfoController, animated: true)
    }
}
