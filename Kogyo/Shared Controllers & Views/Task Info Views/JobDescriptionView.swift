//
//  JobDescriptionView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class JobDescriptionView: UIView {
    // UIView responsible for showing task description
    
    // MARK: - Variables
    let cf = CustomFunctions()
    
    
    // MARK: - UI Components
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        textView.leftSpace()
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        return textView
    }()
    
    
    // MARK: - Life Cycle
    init(for job: TaskClass) {
        
        self.descriptionTextView.text = job.description
        
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let descriptionTitle = cf.createFormLabel(for: "Description")
        
        self.addSubview(descriptionTitle)
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            descriptionTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionTitle.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 80),
            
        ])
    }

    // MARK: - Selectors

}
