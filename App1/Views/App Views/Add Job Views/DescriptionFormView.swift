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
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Please describe the job in detail..."
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = Constants().darkWhiteColor
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.leftSpace()
        return textView
    }()
    
    private let descriptionToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .systemBlue
        return toolbar
    }()
    
    private lazy var descriptionToolbarDone = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(doneButtonPressed)
    )
    
    private lazy var flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        descriptionTextView.delegate = self
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let descriptionLabel = cf.createFormLabel(for: "Description")
        
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.inputAccessoryView = descriptionToolbar
        
        descriptionToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        descriptionToolbar.setItems([flexButton, descriptionToolbarDone], animated: true)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    // MARK: - Selectors
    @objc func doneButtonPressed() {
        descriptionTextView.resignFirstResponder()
    }
}

extension DescriptionFormView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please describe the job in detail..."
            textView.textColor = UIColor.lightGray
        }
    }
}
