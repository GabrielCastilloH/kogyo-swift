//
//  CustomerSettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class CustomerSettingsController: UIViewController {
    // MARK: - Variables
    var settingsOption : [SettingsOption] = [
        SettingsOption(title: "Personal Information",
                      icon: UIImage(systemName: "person")
                     ),
        SettingsOption(title: "Notifications",
                      icon: UIImage(systemName: "bell")
                     ),
        SettingsOption(title: "Payment",
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
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Constants().darkGrayColor, for: .normal)
        button.layer.borderColor = Constants().darkGrayColor.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
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
        
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -500),
            
            logoutButton.topAnchor.constraint(equalTo: self.settingsTable.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            aboutLabel.topAnchor.constraint(equalTo: self.logoutButton.bottomAnchor, constant: 40),
            aboutLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    func presentSettingsController(with settingOption: String ) {
        var viewController: UIViewController
        
        switch settingOption {
        case "Personal Information":
            viewController = PersonalInfoController()
        case "Notifications":
            viewController = NotificationSettingsController()
        case "Payment":
            viewController = PaymentSettingsController()
        case "Support":
            viewController = SupportController()
        default:
            viewController = CustomerSettingsController() // Default option
        }
        
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: -  Settings Table Delegate
extension CustomerSettingsController: UITableViewDelegate, UITableViewDataSource {
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
