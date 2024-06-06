//
//  SearchBarView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

class SearchBarView: UIView {
    
    // MARK: - UI Components
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What would you like done today?"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = Constants().darkWhiteColor
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: textField.frame.size.height))
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        return textField
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants().darkGrayColor
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            icon.topAnchor.constraint(equalTo: self.topAnchor, constant: -1),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}


