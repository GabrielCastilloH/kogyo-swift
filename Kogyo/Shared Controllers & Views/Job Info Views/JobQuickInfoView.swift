//
//  JobQuickInfoView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class JobQuickInfoView: UIView {
    // MARK: - Variables
    let cf = CustomFunctions()
    
    
    // MARK: - UI Components
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = Constants().darkGrayColor
        button.backgroundColor = UIColor(white: 1, alpha: 0)
        button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        return button
    }()
    
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location")
        imageView.tintColor = Constants().darkGrayColor
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.text = "Loading..."
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.text = "Loading..."
        return label
    }()
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.text = "Loading..."
        return label
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.text = "Loading..."
        return label
    }()
    
    
    // MARK: - Life Cycle
    init(for job: Task) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d, h:mm a"
        let dateFormatted = formatter.string(from: job.dateTime)
        
        self.dateLabel.text = dateFormatted
        self.addressLabel.text = job.location
        self.hoursLabel.text = String(job.expectedHours) + " hours"
        self.paymentLabel.text = "$" + String(job.payment)
        
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let locationTitle = cf.createFormLabel(for: "Location:")
        let dateTitle = cf.createFormLabel(for: "Date & Time:")
        let expectedHoursTitle = cf.createFormLabel(for: "Expected to Take:")
        let paymentTitle = cf.createFormLabel(for: "Payment:")
        
        
        self.addSubview(locationTitle)
        locationTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(locationIcon)
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dateTitle)
        dateTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(expectedHoursTitle)
        expectedHoursTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(hoursLabel)
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(paymentTitle)
        paymentTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(paymentLabel)
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            locationTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            locationTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            locationIcon.bottomAnchor.constraint(equalTo: locationTitle.bottomAnchor),
            locationIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            locationIcon.heightAnchor.constraint(equalToConstant: 25),
            
            locationButton.topAnchor.constraint(equalTo: locationIcon.topAnchor),
            locationButton.bottomAnchor.constraint(equalTo: locationIcon.bottomAnchor),
            locationButton.leadingAnchor.constraint(equalTo: locationTitle.leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: locationIcon.trailingAnchor),
            
            addressLabel.leadingAnchor.constraint(equalTo: locationTitle.trailingAnchor, constant: 5),
            addressLabel.widthAnchor.constraint(equalToConstant: 220),
            
            dateTitle.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 10),
            dateTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            dateLabel.bottomAnchor.constraint(equalTo: dateTitle.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dateTitle.trailingAnchor, constant: 5),
            dateLabel.widthAnchor.constraint(equalToConstant: 200),
            
            expectedHoursTitle.topAnchor.constraint(equalTo: dateTitle.bottomAnchor, constant: 10),
            expectedHoursTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            hoursLabel.bottomAnchor.constraint(equalTo: expectedHoursTitle.bottomAnchor),
            hoursLabel.leadingAnchor.constraint(equalTo: expectedHoursTitle.trailingAnchor, constant: 5),
            hoursLabel.widthAnchor.constraint(equalToConstant: 200),
            
            paymentTitle.topAnchor.constraint(equalTo: expectedHoursTitle.bottomAnchor, constant: 10),
            paymentTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            paymentLabel.bottomAnchor.constraint(equalTo: paymentTitle.bottomAnchor),
            paymentLabel.leadingAnchor.constraint(equalTo: paymentTitle.trailingAnchor, constant: 5),
            paymentLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
    }

    // MARK: - Selectors
    @objc func didTapLocationButton() {
        print("this should just show an address")
    }
}
