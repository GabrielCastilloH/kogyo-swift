//
//  JobHelperInfoView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class JobHelperInfoView: UIView {
    
    // MARK: - Variables
    let cf = CustomFunctions()
    let helperUID: String
    let storageRef = Storage.storage().reference()
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cleaning")
        imageView.layer.cornerRadius = 50 // height divided by 2
        imageView.clipsToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = Constants().lightGrayColor.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let helperNameTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = ""
        return label
    }()
    
    private let helperLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.text = "Helper"
        return label
    }()
    
    let helperDescriptionTextField: UITextView = {
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
    
    init(for job: Job) {
        self.helperUID = job.helper!
        super.init(frame: .zero)
        
        // Fetching heler data
        FirestoreHandler.shared.fetchHelper(for: helperUID) { result in
            switch result {
            case .success(let (helper, image)):
                
                self.profileImageView.image = image
                let firstName = helper.firstName
                let lastName = helper.lastName
                self.helperNameTitle.text = firstName + " " + lastName
                self.helperDescriptionTextField.text = helper.description
                
            case .failure(let error):
                print("Error fetching helper: \(error.localizedDescription)")
            }
        }
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    private func setupUI() {

        self.addSubview(helperNameTitle)
        helperNameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(helperLabel)
        helperLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(helperDescriptionTextField)
        helperDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            helperNameTitle.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            helperNameTitle.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: -20),
            helperNameTitle.widthAnchor.constraint(equalToConstant: 150),
            
            helperLabel.leadingAnchor.constraint(equalTo: helperNameTitle.leadingAnchor),
            helperLabel.bottomAnchor.constraint(equalTo: self.helperNameTitle.topAnchor, constant: -3),
            
            helperDescriptionTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            helperDescriptionTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            helperDescriptionTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            helperDescriptionTextField.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    // MARK: - Functions
}
