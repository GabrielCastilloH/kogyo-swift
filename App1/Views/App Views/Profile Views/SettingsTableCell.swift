//
//  SearchTableCell.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    static let identifier = "ProfileCell"

    // MARK: - UI Components
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.tintColor = Constants().darkGrayColor
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
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
    public func configureCell(with profileOption: SettingsOption) {
        self.myImageView.image = profileOption.icon
        self.label.text = profileOption.title
    }
    
    
    private func setupUI() {
        accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            myImageView.widthAnchor.constraint(equalToConstant: 30),
            myImageView.heightAnchor.constraint(equalToConstant: 30),
            
            label.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
}
