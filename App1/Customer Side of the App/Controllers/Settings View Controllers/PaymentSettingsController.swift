//
//  PaymentSettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class PaymentSettingsController: UIViewController {
    // MARK: - Variables
    
    
    // MARK: - UI Components
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Payment functionality with multiple payment methods is coming soon..."
        return label
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
        self.navigationItem.title = "Payment"
    }
    
    
    private func setupUI() {
        self.view.addSubview(paymentLabel)
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            paymentLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            paymentLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    // MARK: - Selectors
    
    
}
