//
//  JobCategoryButton.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobCategoryButton: UIView {
    
    
    // MARK: - UI Components
    let imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "Electrical") // remove this line, add it later.
        imgV.layer.cornerRadius = 0.25
        return imgV
    }()
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 140), // I dont know how to set it exactly = to height
        ])
    }
    
    // MARK: - Selectors
    
    

}
