//
//  RegisterController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class RegisterController: UIViewController {
    
    
    // MARK: - Variables
    private let headerView = AuthHeaderView(title: "Sign Up", subtitle: "Create a new account")
    private let firstNameField = CustomAuthTextField(fieldType: .firstName)
    private let lastNameField = CustomAuthTextField(fieldType: .lastName)
    private let emailField = CustomAuthTextField(fieldType: .email)
    private let passwordField = CustomAuthTextField(fieldType: .password)
    private let confirmPasswordField = CustomAuthTextField(fieldType: .confirmPassword)
    
    private let signUpButton = CustomAuthButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let hasAccountButton = CustomAuthButton(title: "Have an account? Sign In", fontSize: .med)
    
    var keyboardHeight: CGFloat = 300
    
    // MARK: - UI Components
    let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions, and you acknowledge that you have read our Privacy Policy.")
        attributedString.addAttribute(.link, value: "terms://t&c", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttribute(.link, value: "privacy://pp", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        tv.attributedText = attributedString
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.font = .systemFont(ofSize: 11, weight: .regular)
        tv.backgroundColor = .clear
        tv.textColor = .label
        tv.isSelectable = true
        tv.delaysContentTouches = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let lineBreak: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.termsTextView.delegate = self
        self.confirmPasswordField.delegate = self
        self.passwordField.delegate = self
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.hasAccountButton.addTarget(self, action: #selector(didTapHasAccount), for: .touchUpInside)
    }
    
    @objc private func didTapSignUp() {
        let registerUserRequest = RegisterUserRequest(
            firstName: self.firstNameField.text ?? "",
            lastName: self.lastNameField.text ?? "",
            email: self.emailField.text ?? "",
            password: self.passwordField.text  ?? ""
        )
        
        // First Name Check:
        if !Validator.isNameValid(for: registerUserRequest.firstName) {
            AlertManager.showInvalidFirstNameAlert(on: self)
            return
        }
        
        // Last Name Check:
        if !Validator.isNameValid(for: registerUserRequest.lastName) {
            AlertManager.showInvalidLastNameAlert(on: self)
            return
        }
        
        // Email Check:
        if !Validator.isEmailValid(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Passwords Match:
        if registerUserRequest.password != confirmPasswordField.text ?? "" {
            AlertManager.showPasswordsDontMatchAlert(on: self)
        }
        
        // Password Check:
        if !Validator.isPasswordValid(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }

            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }

            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    Task {
                       await sceneDelegate.checkAuthentication()
                    }
                }
            }
        }
    }
    
    @objc private func didTapHasAccount() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(firstNameField)
        self.view.addSubview(lastNameField)
        self.view.addSubview(lineBreak)
        
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(confirmPasswordField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(termsTextView)
        self.view.addSubview(hasAccountButton)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.firstNameField.translatesAutoresizingMaskIntoConstraints = false
        self.lastNameField.translatesAutoresizingMaskIntoConstraints = false
        self.lineBreak.translatesAutoresizingMaskIntoConstraints = false
        
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.hasAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.firstNameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.firstNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.firstNameField.heightAnchor.constraint(equalToConstant: 55),
            self.firstNameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 12),
            self.lastNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.lastNameField.heightAnchor.constraint(equalToConstant: 55),
            self.lastNameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.lineBreak.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 12),
            self.lineBreak.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.lineBreak.heightAnchor.constraint(equalToConstant: 1),
            self.lineBreak.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95),
            
            self.emailField.topAnchor.constraint(equalTo: lineBreak.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 18),
            self.passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 18),
            self.confirmPasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.confirmPasswordField.heightAnchor.constraint(equalToConstant: 55),
            self.confirmPasswordField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 18),
            self.signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 5),
            self.termsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.hasAccountButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 0),
            self.hasAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.hasAccountButton.heightAnchor.constraint(equalToConstant: 55),
            self.hasAccountButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
}

extension RegisterController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            self.showWebViewController(with: "https://policies.google.com/terms?hl=en-US")
        } else if URL.scheme == "privacy" {
            self.showWebViewController(with: "https://policies.google.com/privacy?hl=en-US")
        }
        
        return true
    }
    
    private func showWebViewController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // Makes sure you don't select anything, but can click links. dont ask me why.
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}

extension RegisterController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.4,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = -self.keyboardHeight + 50
                })
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        _ = self.textFieldShouldEndEditing(textField)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.1,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = 0
                })
        }
        return true
    }
}

