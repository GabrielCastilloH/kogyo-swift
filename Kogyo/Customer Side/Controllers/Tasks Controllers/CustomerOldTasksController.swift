//
//  CustomerOldTasksController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/2/24.
//

import UIKit

class CustomerOldTasksController: UIViewController {
    // Screen with all the tasks the user has completed in the past.
    
    // MARK: - Variables
    var oldTasks: [TaskClass] = []
    
    // MARK: - UI Components
    private let oldTasksTableView: UITableView = {
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
        label.text = "You do not have any completed tasks. Please go to the home screen to view available tasks."
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
                noTasksLabel.widthAnchor.constraint(equalToConstant: 200),
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
            oldTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            oldTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            oldTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    private func reloadTaskData() {
        self.oldTasks = Array(DataManager.shared.customerOldTasks.values).sorted { $0.dateAdded > $1.dateAdded }
        self.oldTasksTableView.reloadData()
        
        if self.oldTasks.isEmpty {
            self.noTasksSetup()
        } else {
            self.noTasksLabel.isHidden = true
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension CustomerOldTasksController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oldTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentTasksCell.identifier, for: indexPath) as? CurrentTasksCell else {
            fatalError("The SearchTableView could not dequeue a CurrentTasksCell in CustomerOldTasksController.")
        }
        
        let oldTask = self.oldTasks[indexPath.row]
        cell.configureCell(for: oldTask)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.oldTasks[indexPath.row]
        let taskId = task.taskUID
        
        let taskInfoController = CustomerTaskInfoController(for: task, jobUID: taskId)
        
        taskInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(taskInfoController, animated: true)
    }
}
