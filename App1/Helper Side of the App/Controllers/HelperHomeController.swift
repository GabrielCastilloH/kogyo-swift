//
//  HelperHomeController.swift
//  App1
//
//  Created by Gabriel Castillo on 7/10/24.
//

import UIKit

class HelperHomeController: UIViewController {

    // MARK: - Variables
    
    
    // MARK: - UI Components
    private let homeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Dashboard"
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        self.view.addSubview(homeHeading)
        homeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeHeading.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            homeHeading.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
        ])
    }
    
    // MARK: - Selectors
    
    

}
