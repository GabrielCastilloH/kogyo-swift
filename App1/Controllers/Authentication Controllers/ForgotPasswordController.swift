//
//  ForgotPasswordController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    
    // MARK: - Variables
    private let headerView = AuthHeaderView(title: "Forgot Password", subtitle: "Reset your password")
    private let emailField = CustomAuthTextField(fieldType: .email)
    private let passwordField = CustomAuthTextField(fieldType: .password)
    
    private let resetPasswordButton = CustomAuthButton(title: "Reset Password", hasBackground: true, fontSize: .big)
    
    private var firstTime = true
    
    // MARK: - UI Components
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTouchResetPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func didTouchResetPassword() {
        let email = self.emailField.text ?? ""
        if !Validator.isEmailValid(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
        }

        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 18),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    
}
