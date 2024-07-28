//
//  CancelTaskController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/27/24.
//

import UIKit
import UIKit

class CancelTaskController: UIViewController {

    // MARK: - Variables
    let selectedTask: TaskClass
    
    private let reasons = [
        "Select Reason",
        "Personal emergency",
        "Scheduling conflict",
        "Job requirements unclear",
        "Customer unreachable",
        "Found a better opportunity",
        "Health issues",
        "Weather conditions",
        "Transportation issues",
        "Safety concerns",
        "Lack of necessary tools/equipment",
        "Payment issues",
        "Job location too far",
        "Conflict with customer",
        "Changed my mind",
        "Task is outside my skill set",
        "Received incomplete or incorrect information",
        "Family obligations",
        "Unexpected personal commitment",
        "Other"
    ]
    
    // MARK: - UI Components
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Canceling a task will incur a $5 fee. Frequent cancellations may result in removal from the platform for Helpers or a suspension of task posting privileges for Customers."
        label.numberOfLines = 0
        return label
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a reason for cancellation:"
        label.textColor = Constants().darkGrayColor
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let reasonPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Task", for: .normal)
        button.backgroundColor = UIColor(red: 0.96, green: 0.27, blue: 0.31, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()


    // MARK: - Life Cycle
    init(selectedTask: TaskClass) {
        self.selectedTask = selectedTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        reasonPicker.delegate = self
        reasonPicker.dataSource = self
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = "Cancel Task"
        
        self.view.addSubview(infoLabel)
        self.view.addSubview(reasonLabel)
        self.view.addSubview(reasonPicker)
        self.view.addSubview(cancelButton)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonPicker.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            reasonLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 40),
            reasonLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            reasonPicker.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 0),
            reasonPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            reasonPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            cancelButton.topAnchor.constraint(equalTo: reasonPicker.bottomAnchor, constant: 30),
            cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 200),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc private func handleCancel() {
        let selectedReasonIndex = reasonPicker.selectedRow(inComponent: 0)
        let selectedReason = reasons[selectedReasonIndex]
        
        if selectedReason == "Select Reason" {
            AlertManager.showInvalidCancelReason(on: self)
            return
        }
        
        // Delete task from Firestore & Datamanager.
        Task {
            do {
                try await FirestoreHandler.shared.deleteTask(
                    taskUID: self.selectedTask.taskUID,
                    userUID: self.selectedTask.userUID
                )
                DataManager.shared.helperMyTasks[self.selectedTask.taskUID] = nil
                
                self.presentMyTasksController()
                
            } catch {
                print("Error Canceling Task: \(error.localizedDescription)")
            }
        }
    }
    
    func presentMyTasksController() {
        if let myTasksController = self.navigationController?.viewControllers.first(where: { $0 is HelperMyTasksController }) {
            self.navigationController?.popToViewController(myTasksController, animated: true)
            AlertManager.showCanceledTaskAlert(on: myTasksController)
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension CancelTaskController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
}
