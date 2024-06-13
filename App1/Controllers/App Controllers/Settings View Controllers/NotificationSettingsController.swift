//
//  NotificationSettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class NotificationSettingsController: UIViewController {

    
    // MARK: - Variables
    
    // MARK: - UI Components
    private let notifyAccepted: UILabel =  {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Notify me when my job is accepted."
        return label
    }()
    
    lazy var notifyAcceptedSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = true
        switchView.addTarget(self, action: #selector(notifyAcceptedSwitchChanged), for: .valueChanged)
        return switchView
    }()
    
    private let notifyMessages: UILabel =  {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "Notify me when I get a message."
        return label
    }()
    
    lazy var notifyMessagesSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = true
        switchView.addTarget(self, action: #selector(notifyMessagesSwitchChanged), for: .valueChanged)
        return switchView
    }()

    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Notifications"
    }
    
    
    private func setupUI() {
        self.view.addSubview(notifyAccepted)
        notifyAccepted.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(notifyMessages)
        notifyMessages.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(notifyAcceptedSwitch)
        notifyAcceptedSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(notifyMessagesSwitch)
        notifyMessagesSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notifyAccepted.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            notifyAccepted.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            notifyAcceptedSwitch.centerYAnchor.constraint(equalTo: notifyAccepted.centerYAnchor),
            notifyAcceptedSwitch.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            notifyMessages.topAnchor.constraint(equalTo: notifyAccepted.bottomAnchor, constant: 30),
            notifyMessages.leadingAnchor.constraint(equalTo: notifyAccepted.leadingAnchor),
            
            notifyMessagesSwitch.centerYAnchor.constraint(equalTo: notifyMessages.centerYAnchor),
            notifyMessagesSwitch.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc func notifyAcceptedSwitchChanged() {
        if notifyAcceptedSwitch.isOn {
            print("please notify me when accepted.")
        } else {
            print("no notifications when accepted plz.")
        }
    }
    
    @objc func notifyMessagesSwitchChanged() {
        if notifyMessagesSwitch.isOn {
            print("notify me when i get hit up right now.")
        } else {
            print("i dont wanna know when ppl slide up my dms.")
        }
    }
}
