//
//  DescriptionFormView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/7/24.
//

import UIKit

class DescriptionFormView: UIView {

    // MARK: - Variables
    let cf = CustomFunctions()
    
    // MARK: - UI Components
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants().darkWhiteColor
        textField.attributedPlaceholder = CustomFunctions()
            .createPlaceholder(for: "Please describe the job in detail...")
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
        return textField
    }()
    
    
    // MARK: - Life Cycle
    init(kind: String) {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let descriptionLabel = cf.createFormLabel(for: "Kind:")
        
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(descriptionTextField)
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionTextField.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 70),
        ])
    }

    // MARK: - Selectors
}
