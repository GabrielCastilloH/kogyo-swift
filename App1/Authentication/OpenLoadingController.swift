//
//  OpenLoadingController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/24/24.
//

import UIKit

class OpenLoadingController: UIViewController {

    // MARK: - Variables
    
    
    // MARK: - UI Components
    private let logoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    // MARK: - Selectors
    
    

}
