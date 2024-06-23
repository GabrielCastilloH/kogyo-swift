//
//  SearchTableCell.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

class CurrentJobsCell: UITableViewCell {
    
    static let identifier = "CurrentJobsCell"

    // MARK: - UI Components
    private let grayBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cleaning")
        imageView.layer.cornerRadius = 40 // height divided by 2
        imageView.clipsToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = Constants().lightGrayColor.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let kindTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.text = "Loading..."
        return label
    }()
    
    private let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    private let helperNameTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.text = "Loading..."
        return label
    }()
    
    private let doneByLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.text = "Done by:"
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    public func configureCell(for job: Job) {
        self.kindTitleLabel.text = job.kind
        self.jobDescriptionLabel.text = job.description
        
        // Fetching helper data from DataManager
        guard let helperUID = job.helperUID else { return }
        let helper = DataManager.shared.helpers[helperUID]
        
        self.profileImageView.image = helper?.profileImage
        let firstName = helper?.firstName ?? "ur"
        let lastName = helper?.lastName ?? "moms gay"
        self.helperNameTitle.text = firstName + " " + lastName.capitalized.prefix(1) + "."
        
//        FirestoreHandler.shared.fetchHelper(for: helperUID) { result in // TODO: make sure it only fetches jobs with helpers!
//            switch result {
//            case .success(let (helperUID, image)):
//                
//                
//            case .failure(let error):
//                print("Error fetching helperUID: \(error.localizedDescription)")
//            }
//        }
    }
    
    
    private func setupUI() {
        self.contentView.addSubview(grayBackground)
        grayBackground.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(kindTitleLabel)
        kindTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(jobDescriptionLabel)
        jobDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(helperNameTitle)
        helperNameTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(doneByLabel)
        doneByLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            grayBackground.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            grayBackground.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            grayBackground.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            grayBackground.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            
            kindTitleLabel.topAnchor.constraint(equalTo: self.grayBackground.topAnchor, constant: 16),
            kindTitleLabel.leadingAnchor.constraint(equalTo: self.grayBackground.leadingAnchor, constant: 15),
            
            jobDescriptionLabel.topAnchor.constraint(equalTo: self.kindTitleLabel.bottomAnchor, constant: 5),
            jobDescriptionLabel.leadingAnchor.constraint(equalTo: self.kindTitleLabel.leadingAnchor),
            jobDescriptionLabel.widthAnchor.constraint(equalToConstant: 140),
            
            profileImageView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor, constant: -10),
            profileImageView.centerYAnchor.constraint(equalTo: self.grayBackground.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            helperNameTitle.bottomAnchor.constraint(equalTo: self.jobDescriptionLabel.bottomAnchor, constant: -5),
            helperNameTitle.widthAnchor.constraint(equalToConstant: 100),
            
            doneByLabel.bottomAnchor.constraint(equalTo: self.helperNameTitle.topAnchor, constant: -3),
            doneByLabel.trailingAnchor.constraint(equalTo: self.profileImageView.leadingAnchor),
            doneByLabel.widthAnchor.constraint(equalToConstant: 85),
            
            helperNameTitle.leadingAnchor.constraint(equalTo: self.doneByLabel.leadingAnchor),

        ])
    }
    
}

