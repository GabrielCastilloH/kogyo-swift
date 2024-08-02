//
//  HelperTaskOptionsController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/27/24.
//

import UIKit

class HelperTaskOptionsController: UIViewController {
    // Options controller, similar to settings controller.
    
    // MARK: - Variables
    let selectedTask: TaskClass
    
    var settingsOption : [SettingsOption] = [
        SettingsOption(title: "Contact Support", icon: UIImage(systemName: "person.circle")),
        SettingsOption(title: "Cancel Task", icon: UIImage(systemName: "xmark.circle")),
        SettingsOption(title: "Complete Task", icon: UIImage(systemName: "checkmark.circle")),
    ]
    
    // MARK: - UI Components
    private let optionsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        return tableView
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
        setupNavBar()
        setupUI()
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Task Options"
    }
    
    private func setupUI() {
        self.view.addSubview(optionsTable)
        optionsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            optionsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            optionsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            optionsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -500),
        ])
    }
    
    // MARK: - Selectors & Functions
    func presentSettingsController(with settingOption: String ) {
        var viewController: UIViewController
        
        switch settingOption {
        case "Contact Support":
            viewController = SupportController()
        case "Cancel Task":
            viewController = CancelTaskController(selectedTask: self.selectedTask)
        case "Complete Task":
            viewController = HelperCompleteTaskController(selectedTaskUID: self.selectedTask.taskUID)
        default:
            viewController = PersonalInfoController() // Default option
        }
        
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: -  Settings Table Delegate
extension HelperTaskOptionsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return settingsOption.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier, for: indexPath) as? SettingsTableCell else {
            fatalError("The OptionTable could not dequeue a SettingsCell in HelperTaskOptionsController") }

        cell.configureCell(with: settingsOption[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSettingsController(with: settingsOption[indexPath.row].title)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
