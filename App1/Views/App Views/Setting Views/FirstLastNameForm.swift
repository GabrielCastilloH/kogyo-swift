//
//  FirstLastNameForm.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class FirstLastNameForm: UIView {
    
    // MARK: - Variables
    let cf = CustomFunctions()
    
    
    // MARK: - UI Components
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "*Click on a name to change it."
        return label
    }()
    
    private let keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .systemBlue
        return toolbar
    }()
    
    private lazy var keyboardToolbarText = UIBarButtonItem(title: "Change your name.", style: .plain, target: nil, action: nil)
    
    private lazy var keyboardToolbarDone = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(pickerToolbarDonePressed)
    )
    
    private lazy var flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
    
    public let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.text = "Loading..."
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.textAlignment = .left
        textField.returnKeyType = .done
        return textField
    }()
    
    public let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.text = "Loading..."
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.textAlignment = .left
        textField.returnKeyType = .done
        return textField
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        keyboardToolbarText.tintColor = .black
        self.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let firstNameTitle = cf.createFormLabel(for: "First Name:")
        let lastNameTitle = cf.createFormLabel(for: "Last Name:")
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        self.keyboardToolbar.setItems([keyboardToolbarText, flexButton, keyboardToolbarDone], animated: true)
        keyboardToolbar.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(firstNameTitle)
        firstNameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lastNameTitle)
        lastNameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(firstNameTextField)
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.inputAccessoryView = keyboardToolbar
        
        self.addSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.inputAccessoryView = keyboardToolbar
        
        
        NSLayoutConstraint.activate([
            firstNameTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            firstNameTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            
            firstNameTextField.bottomAnchor.constraint(equalTo: firstNameTitle.bottomAnchor),
            firstNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            firstNameTextField.widthAnchor.constraint(equalToConstant: 100),
            
            lastNameTitle.topAnchor.constraint(equalTo: firstNameTitle.bottomAnchor, constant: 10),
            lastNameTitle.leadingAnchor.constraint(equalTo: firstNameTitle.leadingAnchor),
            
            lastNameTextField.bottomAnchor.constraint(equalTo: lastNameTitle.bottomAnchor),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.widthAnchor.constraint(equalToConstant: 100),
            
            infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15),
        ])
    }

    // MARK: - Selectors
    @objc func pickerToolbarDonePressed() {
        firstNameTextField.resignFirstResponder()
        firstNameTextField.delegate?.textFieldShouldReturn?(firstNameTextField)
        
        lastNameTextField.resignFirstResponder()
        lastNameTextField.delegate?.textFieldShouldReturn?(lastNameTextField)
    }
}
