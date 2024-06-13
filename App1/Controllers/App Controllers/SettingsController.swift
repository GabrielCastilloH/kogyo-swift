//
//  SettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class SettingsController: UIViewController {
    // MARK: - Variables
    var profileOptions : [ProfileOption] = [
        ProfileOption(title: "Personal Information",
                      icon: UIImage(systemName: "person"),
                      iconBackgroundColor: .systemBlue
                     ),
        ProfileOption(title: "Notifications",
                      icon: UIImage(systemName: "bell"),
                      iconBackgroundColor: .systemPink
                     ),
        ProfileOption(title: "Payment Methods",
                      icon: UIImage(systemName: "person.text.rectangle"),
                      iconBackgroundColor: .systemBlue
                     ),
        ProfileOption(title: "Support",
                      icon: UIImage(systemName: "questionmark.circle"),
                      iconBackgroundColor: .systemBlue
                     ),
    ]
    
    // MARK: - UI Components
    private let settingsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.identifier)
        return tableView
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Constants().lightGrayColor
        label.text = #"Made with ❤️ by Gabriel Castillo\nⓒ 2024 Gabriel Castillo"#
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
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Settings"
    }
    
    private func setupUI() {
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = true
        
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            aboutLabel.topAnchor.constraint(equalTo: settingsTable.bottomAnchor)
        ])
    }
    
    // MARK: - Selectors & Functions
    func presentSettingsController(with profileTitle: String ) {
        var viewController: UIViewController
        
        switch profileTitle {
        case "Profile Information":
            viewController = HomeController()
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
        return profileOptions.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.identifier, for: indexPath) as? ProfileTableCell else {
            fatalError("The SearchTableView could not dequeue a ProfileTableCell in ProfileController.") }

        cell.configureCell(with: profileOptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSettingsController(with: profileOptions[indexPath.row].title)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
