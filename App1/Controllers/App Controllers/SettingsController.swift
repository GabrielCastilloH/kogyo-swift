//
//  SettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class SettingsController: UIViewController {
    // MARK: - Variables
    var settingsOption : [SettingsOption] = [
        SettingsOption(title: "Personal Information",
                      icon: UIImage(systemName: "person")
                     ),
        SettingsOption(title: "Notifications",
                      icon: UIImage(systemName: "bell")
                     ),
        SettingsOption(title: "Payment Methods",
                      icon: UIImage(systemName: "person.text.rectangle")
                     ),
        SettingsOption(title: "Support",
                      icon: UIImage(systemName: "questionmark.circle")
                     ),
    ]
    
    // MARK: - UI Components
    private let settingsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        return tableView
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        
        // Create paragraph style with custom line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 // Adjust line spacing here
        paragraphStyle.alignment = .center
        
        // Create attributed string with the paragraph style
        let attributedText = NSMutableAttributedString(
            string: "Made with ❤️ by Gabriel Castillo \n ⓒ 2024 Gabriel Castillo",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular), // Ensure the font is applied
                .foregroundColor: Constants().lightGrayColor.withAlphaComponent(0.7) // Ensure the color is applied
            ]
        )
        
        // Set the attributed text to the label
        label.attributedText = attributedText
        
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Settings"
    }
    
    private func setupUI() {
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -500),
            
            aboutLabel.topAnchor.constraint(equalTo: self.settingsTable.bottomAnchor, constant: 50),
            aboutLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    func presentSettingsController(with settingOption: String ) {
        var viewController: UIViewController
        
        switch settingOption {
        case "Personal Information":
            viewController = PersonalInfoController()
        case "Your MOms gay":
            viewController = HomeController()
        default:
            viewController = HomeController() // Default option
        }
        
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: -  Settings Table Delegate
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return settingsOption.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier, for: indexPath) as? SettingsTableCell else {
            fatalError("The SearchTableView could not dequeue a ProfileTableCell in ProfileController.") }

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
