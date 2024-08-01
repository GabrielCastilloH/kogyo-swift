//
//  HelperDashboardController.swift
//  App1
//
//  Created by Gabriel Castillo on 7/10/24.
//

import UIKit
import Firebase

class HelperDashboardController: UIViewController {
    // Home screen for helpers, presents all available jobs in their are.
    
    // MARK: - Variables
    var availableTasks: [TaskClass] = []
    
    private var taskListener: ListenerRegistration?
    
    // MARK: - UI Components
    private let homeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Helper Dashboard"
        return label
    }()
    
    private let quoteLabel: UILabel = {
        // TODO: make this text italized
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "\"Any task, a tap away.\""
        return label
    }()
    
    private let moneyEarnedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Money Earned"
        return label
    }()
    
    private let moneyTodayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Today: "
        return label
    }()
    
    private let moneyWeekLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "This week: "
        return label
    }()
    
    private let moneyMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "This month: "
        return label
    }()
    
    private let availableTasksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Available Tasks"
        return label
    }()
    
    // TABLE
    private let availableTasksTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
        label.text = "There are no available tasks. Please check back in later."
        return label
    }()
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.availableTasks = Array(DataManager.shared.helperAvailableTasks.values)
            .sorted { $0.dateAdded > $1.dateAdded }
        self.availableTasksTable.reloadData()
        
        if self.availableTasks.count == 0 {
            self.noTasksLabel.isHidden = false
        } else {
            self.noTasksLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        self.availableTasksTable.delegate = self
        self.availableTasksTable.dataSource = self
        self.setupUI()
        self.listenForAvailableTasks()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(homeHeading)
        homeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(quoteLabel)
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moneyEarnedLabel)
        moneyEarnedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moneyTodayLabel)
        moneyTodayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moneyWeekLabel)
        moneyWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moneyMonthLabel)
        moneyMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(availableTasksLabel)
        availableTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(availableTasksTable)
        availableTasksTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(noTasksLabel)
        noTasksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeHeading.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            homeHeading.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            quoteLabel.topAnchor.constraint(equalTo: homeHeading.bottomAnchor, constant: 7),
            quoteLabel.leadingAnchor.constraint(equalTo: homeHeading.leadingAnchor),
            
            moneyEarnedLabel.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 15),
            moneyEarnedLabel.leadingAnchor.constraint(equalTo: quoteLabel.leadingAnchor),
            
            moneyTodayLabel.topAnchor.constraint(equalTo: moneyEarnedLabel.bottomAnchor, constant: 4),
            moneyTodayLabel.leadingAnchor.constraint(equalTo: moneyEarnedLabel.leadingAnchor),
            
            moneyWeekLabel.topAnchor.constraint(equalTo: moneyTodayLabel.bottomAnchor, constant: 3),
            moneyWeekLabel.leadingAnchor.constraint(equalTo: moneyTodayLabel.leadingAnchor),
            
            moneyMonthLabel.topAnchor.constraint(equalTo: moneyWeekLabel.bottomAnchor, constant: 3),
            moneyMonthLabel.leadingAnchor.constraint(equalTo: moneyWeekLabel.leadingAnchor),
            
            availableTasksLabel.topAnchor.constraint(equalTo: moneyMonthLabel.bottomAnchor, constant: 15),
            availableTasksLabel.leadingAnchor.constraint(equalTo: moneyMonthLabel.leadingAnchor),
            
            availableTasksTable.topAnchor.constraint(equalTo: availableTasksLabel.bottomAnchor, constant: 5),
            availableTasksTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            availableTasksTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            availableTasksTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            noTasksLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noTasksLabel.centerYAnchor.constraint(equalTo: availableTasksTable.centerYAnchor),
            noTasksLabel.widthAnchor.constraint(equalToConstant: 250)
            
        ])
    }
    
    // MARK: - Selectors & Functions
    private func listenForAvailableTasks() {
        let db = Firestore.firestore()
        let taskRef = db.collection("tasks")
        
        taskListener = taskRef.addSnapshotListener { [weak self] querySnapshot, error in
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
                if documentChange.type == .added {
                    let document = documentChange.document
                    let data = document.data()
                    
                    // Fetch media data asynchronously
                    Task {
                        // NOTE: CHANGED THIS TO JOBS! AS PARENT FOLDER
                        let mediaData = try? await FirestoreHandler.shared.fetchJobMedia(taskId: document.documentID, parentFolder: .jobs) // Fetch media data
                        
                        let newTask = CustomFunctions.shared.taskFromData(
                            for: document.documentID, 
                            data: data,
                            media: mediaData ?? []
                        )
                        
                        // Update DataManager
                        DataManager.shared.helperAvailableTasks[document.documentID] = newTask
                        
                        // Update local availableTasks and reload the table
                        // TODO: Set the data manager as the data source for table data!
                        self.availableTasks = Array(DataManager.shared.helperAvailableTasks.values)
                            .sorted { $0.dateAdded > $1.dateAdded }
                        self.availableTasksTable.reloadData()
                        
                    }
                } else if documentChange.type == .removed {
                    let taskUID = documentChange.document.documentID
                    DataManager.shared.helperAvailableTasks[taskUID] = nil
                    self.availableTasks = Array(DataManager.shared.helperAvailableTasks.values)
                        .sorted { $0.dateAdded > $1.dateAdded }
                    self.availableTasksTable.reloadData()
                }
                
                // Update noTasksLabel visibility
                self.noTasksLabel.isHidden = self.availableTasks.count > 0
            }
        }
    }
}

extension HelperDashboardController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return self.availableTasks.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HelperCurrentTasksCell.identifier, for: indexPath) as? HelperCurrentTasksCell else {
            fatalError("The availableTasksTable could not dequeue a HelperCurrentTaskCell in HelperHomeController.")
        }
        
        let currentTask = self.availableTasks[indexPath.row]
        cell.configureCell(for: currentTask)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Present available task info controller.
        let task = self.availableTasks[indexPath.row]
        let taskID = task.taskUID
        
        let taskInfoController = AvailableTaskInfoController(for: task, taskUID: taskID)
        
        taskInfoController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(taskInfoController, animated: true)
    }
}

