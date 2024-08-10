//
//  MaterialsCell.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/10/24.
//

import UIKit

class MaterialsCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure labels
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .right
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with material: Material) {
        nameLabel.text = material.name
        priceLabel.text = String(format: "$%.2f", material.price)
    }
}
