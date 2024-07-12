//
//  HelperCurrentTasksCell.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class HelperCurrentTasksCell: UITableViewCell {
    
    static let identifier = "HelperCurrentTasksCell"

    // MARK: - UI Components
    private let grayBackground: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 15
        return view
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
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    public func configureCell(for job: Task) {
        self.kindTitleLabel.text = job.kind
        self.jobDescriptionLabel.text = job.description
    }
    
    
    private func setupUI() {
        self.contentView.addSubview(grayBackground)
        grayBackground.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(kindTitleLabel)
        kindTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(jobDescriptionLabel)
        jobDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        
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

        ])
    }
    
}

