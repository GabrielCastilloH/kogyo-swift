//
//  SupportController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class SupportController: UIViewController {
    
    // MARK: - Variables
    let phoneNumberString = "+1 (717) 550-1675"
    let phoneNumberInt = 07175501675
    let email = "support@app1.com"
    
    // MARK: - UI Components
    private let supportLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Customer satisfaction is our number 1 priority. If any helper has done a job you are not satisfied with please let us know through one of the options below, so we can fix the issue and prevent it from happening again. Thank you for using our app."
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        return button
    }()
    
    private let phoneBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderColor = Constants().lightGrayColor.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let phoneIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone")
        imageView.tintColor = Constants().darkGrayColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let phoneLabelTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let phoneDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "We answer phone calls within 5 minutes."
        return label
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        return button
    }()
    
    private let emailBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.borderColor = Constants().lightGrayColor.withAlphaComponent(0.7).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let emailIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = Constants().darkGrayColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let emailLabelTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let emailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "We answer emails within 1 business day."
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.phoneLabelTitle.text = self.phoneNumberString
        self.emailLabelTitle.text = self.email
        
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() { // TODO: Move the setupnavbar function to the custom functions file.
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Support"
    }
    
    private func setupUI() {
        self.view.addSubview(supportLabel)
        supportLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(phoneButton)
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(phoneBorderView)
        phoneBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(phoneIconView)
        phoneIconView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(phoneLabelTitle)
        phoneLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(phoneDescriptionLabel)
        phoneDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailButton)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailBorderView)
        emailBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailIconView)
        emailIconView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailLabelTitle)
        emailLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emailDescriptionLabel)
        emailDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            supportLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            supportLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            supportLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            phoneBorderView.topAnchor.constraint(equalTo: self.supportLabel.bottomAnchor, constant: 20),
            phoneBorderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            phoneBorderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            phoneBorderView.heightAnchor.constraint(equalToConstant: 100),
            
            phoneButton.topAnchor.constraint(equalTo: self.phoneBorderView.topAnchor),
            phoneButton.bottomAnchor.constraint(equalTo: self.phoneBorderView.bottomAnchor),
            phoneButton.leadingAnchor.constraint(equalTo: self.phoneBorderView.leadingAnchor),
            phoneButton.trailingAnchor.constraint(equalTo: self.phoneBorderView.trailingAnchor),

            phoneIconView.topAnchor.constraint(equalTo: self.phoneBorderView.topAnchor, constant: 20),
            phoneIconView.leadingAnchor.constraint(equalTo: self.phoneBorderView.leadingAnchor, constant: 20),
            phoneIconView.widthAnchor.constraint(equalToConstant: 30),
            phoneIconView.heightAnchor.constraint(equalToConstant: 30),
            
            phoneLabelTitle.leadingAnchor.constraint(equalTo: self.phoneIconView.trailingAnchor, constant: 10),
            phoneLabelTitle.centerYAnchor.constraint(equalTo: self.phoneIconView.centerYAnchor),
            
            phoneDescriptionLabel.topAnchor.constraint(equalTo: self.phoneIconView.bottomAnchor, constant: 10),
            phoneDescriptionLabel.leadingAnchor.constraint(equalTo: self.phoneIconView.leadingAnchor),
            
            emailBorderView.topAnchor.constraint(equalTo: self.phoneBorderView.bottomAnchor, constant: 20),
            emailBorderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailBorderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            emailBorderView.heightAnchor.constraint(equalToConstant: 100),
            
            emailButton.topAnchor.constraint(equalTo: self.emailBorderView.topAnchor),
            emailButton.bottomAnchor.constraint(equalTo: self.emailBorderView.bottomAnchor),
            emailButton.leadingAnchor.constraint(equalTo: self.emailBorderView.leadingAnchor),
            emailButton.trailingAnchor.constraint(equalTo: self.emailBorderView.trailingAnchor),
            
            emailIconView.topAnchor.constraint(equalTo: self.emailBorderView.topAnchor, constant: 20),
            emailIconView.leadingAnchor.constraint(equalTo: self.emailBorderView.leadingAnchor, constant: 20),
            emailIconView.widthAnchor.constraint(equalToConstant: 30),
            emailIconView.heightAnchor.constraint(equalToConstant: 30),
            
            emailLabelTitle.leadingAnchor.constraint(equalTo: self.emailIconView.trailingAnchor, constant: 10),
            emailLabelTitle.centerYAnchor.constraint(equalTo: self.emailIconView.centerYAnchor),
            
            emailDescriptionLabel.topAnchor.constraint(equalTo: self.emailIconView.bottomAnchor, constant: 10),
            emailDescriptionLabel.leadingAnchor.constraint(equalTo: self.emailIconView.leadingAnchor),
        ])
        
        view.bringSubviewToFront(phoneButton)
        view.bringSubviewToFront(emailButton)
    }
    
    // MARK: - Selectors
    @objc func didTapPhoneButton() {
        if let url = URL(string: "tel://\(self.phoneNumberInt)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    @objc func didTapEmailButton() {
        if let url = URL(string: "mailto:\(self.email)") {
            UIApplication.shared.open(url)
        }
    }
}
