//
//  CategoriesTableCell.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class CategoriesTableCell: UITableViewCell {
    
    static let identifier = "CategoriesCell"

    // MARK: - UI Components
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    public func configureCell(with category: JobCategoryView) {
        
        self.contentView.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            category.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            category.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            category.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
}
