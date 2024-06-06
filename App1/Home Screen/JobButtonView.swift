//
//  JobButton.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobButtonView: UIView {
    // The buttons with the name of the different jobs available. (under the home category heading.
    
    // MARK: - UI Components
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient1")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let jobLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1, alpha: 0.0)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(frame: .zero)
        jobLabel.text = title
        imageView.image = UIImage(named: title)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(gradientImage)
        gradientImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(jobLabel)
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
    
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            jobLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 5),
            jobLabel.widthAnchor.constraint(equalToConstant: 120),
            
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            gradientImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            gradientImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            gradientImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            gradientImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
    }
    
    // MARK: - Selectors
    @objc func didTapButton(sender: UIButton) {
        print(sender.titleLabel?.text ?? "damn i just got touched up inside real hard.")
    }

}
