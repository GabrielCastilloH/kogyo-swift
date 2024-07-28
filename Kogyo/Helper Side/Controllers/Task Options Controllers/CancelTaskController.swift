//
//  CancelTaskController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/27/24.
//

import UIKit

class CancelTaskController: UIViewController {

    
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
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        self.navigationItem.title = "Cancel Task"
        
        self.view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
        ])
    }
    
    // MARK: - Selectors
}
