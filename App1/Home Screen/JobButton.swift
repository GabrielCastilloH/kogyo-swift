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
//        button.setTitle("Loading...", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 0.25
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
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 4
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            button.heightAnchor.constraint(equalTo: self.heightAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.centerYAnchor.constraint (equalTo: self.centerYAnchor, constant: 0)
        ])
    }
    
    // MARK: - Selectors
    @objc func didTapButton() {
        print("hey i got touched up inside.")
    }

}
