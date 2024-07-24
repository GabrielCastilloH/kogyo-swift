//
//  HelperCurrentTasksCell.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class HelperCurrentTasksCell: UITableViewCell {
    // Table cell of a task accepted by a helper.
    
    static let identifier = "HelperCurrentTasksCell"

    // MARK: - UI Components
    public let grayBackground: UIView = {
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
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 21, weight: .regular)
        label.text = "?? km away"
        return label
    }()
    
    private let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Date: "
        return label
    }()
    
    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Loading..."
        return label
    }()
    
    private let exHoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Expected Hours: "
        return label
    }()
    
    private let exHoursValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Loading..."
        return label
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Payment: "
        return label
    }()
    
    private let paymentValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Loading..."
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
    public func configureCell(for job: TaskClass) {
        self.kindTitleLabel.text = job.kind
        self.jobDescriptionLabel.text = "\(job.description)\n"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM d, h:mm a"
        let dateFormatted = formatter.string(from: job.dateTime)
        self.dateValueLabel.text = "\(dateFormatted)"
        self.exHoursValueLabel.text = "\(job.expectedHours)"
        self.paymentValueLabel.text = "$\(job.payment)"
    }
    
    
    private func setupUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(grayBackground)
        grayBackground.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(kindTitleLabel)
        kindTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(jobDescriptionLabel)
        jobDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(dateValueLabel)
        dateValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(exHoursLabel)
        exHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(exHoursValueLabel)
        exHoursValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(paymentLabel)
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(paymentValueLabel)
        paymentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grayBackground.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            grayBackground.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            grayBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            grayBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
            kindTitleLabel.topAnchor.constraint(equalTo: self.grayBackground.topAnchor, constant: 13),
            kindTitleLabel.leadingAnchor.constraint(equalTo: self.grayBackground.leadingAnchor, constant: 16),
            
            distanceLabel.leadingAnchor.constraint(equalTo: kindTitleLabel.trailingAnchor, constant: 10),
            distanceLabel.bottomAnchor.constraint(equalTo: kindTitleLabel.bottomAnchor, constant: 0),
            
            jobDescriptionLabel.topAnchor.constraint(equalTo: self.kindTitleLabel.bottomAnchor, constant: -2),
            jobDescriptionLabel.leadingAnchor.constraint(equalTo: self.kindTitleLabel.leadingAnchor),
            jobDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            jobDescriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.topAnchor.constraint(equalTo: jobDescriptionLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: self.jobDescriptionLabel.leadingAnchor),
            
            dateValueLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            dateValueLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            
            exHoursLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 1),
            exHoursLabel.leadingAnchor.constraint(equalTo: self.jobDescriptionLabel.leadingAnchor),
            
            exHoursValueLabel.leadingAnchor.constraint(equalTo: exHoursLabel.trailingAnchor),
            exHoursValueLabel.bottomAnchor.constraint(equalTo: exHoursLabel.bottomAnchor),
            
            paymentLabel.topAnchor.constraint(equalTo: exHoursLabel.bottomAnchor, constant: 1),
            paymentLabel.leadingAnchor.constraint(equalTo: self.jobDescriptionLabel.leadingAnchor),

            paymentValueLabel.leadingAnchor.constraint(equalTo: paymentLabel.trailingAnchor),
            paymentValueLabel.bottomAnchor.constraint(equalTo: paymentLabel.bottomAnchor),
        ])
    }
    
}

