//
//  JobButton.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class JobButton: UIView {
    
    
    // MARK: - UI Components
//    let imageView: UIImageView = {
//        let imgV = UIImageView()
//        imgV.image = UIImage(named: "Electrical") // remove this line, add it later.
//        imgV.layer.cornerRadius = 0.25
//        return imgV
//    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life Cycle
    init(title: String) {
        super.init(frame: .zero)
        button.setTitle(title, for: .normal)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .white
//        self.layer.cornerRadius = 25
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func didTapButton() {
        print("hey i got touched up inside.")
    }

}
