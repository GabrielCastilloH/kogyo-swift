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
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
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
    public func configureCell(with image: UIImage, and title: String) {
        self.myImageView.image = image
        self.label.text = title
    }
    
    
    private func setupUI() {
        self.contentView.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor, constant: 0),
            myImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 60),
            myImageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    
}
