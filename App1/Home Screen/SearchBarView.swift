//
//  SearchBarView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

class SearchBarView: UIView {
    
    // MARK: - UI Components
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What would you like to get done today?"
        textField.layer.cornerRadius = 25
        textField.backgroundColor = Constants().lightGrayColor
        return textField
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
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
        self.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: self.topAnchor),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icon.widthAnchor.constraint(equalToConstant: 50),
            
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }
}


