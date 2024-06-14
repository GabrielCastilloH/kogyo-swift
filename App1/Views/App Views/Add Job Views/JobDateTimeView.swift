//
//  JobDateTimeView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class JobDateTimeView: UIView {
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .left
        label.text = "Click to set location"
        return label
    }()
    
    public let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.now
        datePicker.maximumDate = Date.init(timeIntervalSinceNow: 604800)
        return datePicker
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let locationLabel = cf.createFormLabel(for: "Location:")
        let dateLabel = cf.createFormLabel(for: "Date & Time:")
        
        self.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(locationIcon)
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            locationIcon.bottomAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            locationIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            locationIcon.heightAnchor.constraint(equalToConstant: 25),
            
            locationButton.topAnchor.constraint(equalTo: locationIcon.topAnchor),
            locationButton.bottomAnchor.constraint(equalTo: locationIcon.bottomAnchor),
            locationButton.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: locationIcon.trailingAnchor),
            
            addressLabel.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 5),
            addressLabel.widthAnchor.constraint(equalToConstant: 220),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePicker.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 2),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -27),
            
        ])
    }

    // MARK: - Selectors
    @objc func didTapLocationButton() {
        print("good luck with the location functionality.")
    }

}
