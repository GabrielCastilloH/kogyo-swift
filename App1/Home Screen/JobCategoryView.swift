//
//  JobTypeView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobCategoryView: UIView {

    // MARK: - UI Components
    private let header = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()
    
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(frame: .zero)
        
        header.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    

}
