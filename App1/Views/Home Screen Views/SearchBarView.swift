//
//  SearchBarView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

protocol CustomSearchBarDelegate {
    func didClickCancel()
}

class SearchBarView: UIView {
    
    var delegate: CustomSearchBarDelegate?
    
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
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants().darkGrayColor
        return imageView
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        button.backgroundColor = .clear
        button.contentMode = .scaleAspectFit
        button.tintColor = Constants().darkGrayColor
        return button
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        self.cancelButton.showHideView(0)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: -1),
            searchIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            searchIcon.widthAnchor.constraint(equalToConstant: 30),
            
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    // MARK: - Selectors
    @objc func cancelButtonClicked() {
        delegate?.didClickCancel()
    }
}


