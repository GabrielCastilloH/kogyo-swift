//
//  CustomAuthTextField.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//
import UIKit

class CustomAuthTextField: UITextField {

    // Create values of the different types the custom text field can have.
    enum CustomTextFieldType {
        case firstName, lastName, email, password, confirmPassword
    }
    
    // Creates a varialbe to be given a value when text field is initialized
    // Will decide which type of text field this one is.
    private let authFieldtype: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        authFieldtype = fieldType
        super.init(frame: .zero)
        setupUI()
        
        switch fieldType {
        case .firstName:
            self.placeholder = "First Name"
        case .lastName:
            self.placeholder = "Last Name"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
            
        case .confirmPassword:
            self.placeholder = "Confirm Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
        
    }
    
    private func setupUI() {
        // Setup the UI for the textfield
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        // Moves the cursor to the right, so it's not touching the border of the text field.
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
