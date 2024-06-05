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
        button.layer.cornerRadius = 0.25
        button.addTarget(JobButton.self, action: #selector(didTapButton), for: .touchUpInside)
        return button
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
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            button.widthAnchor.constraint(equalToConstant: 140), // I dont know how to set it exactly = to height
        ])
    }
    
    // MARK: - Selectors
    @objc func didTapButton() {
        print("hey i got touched up inside.")
    }

}
