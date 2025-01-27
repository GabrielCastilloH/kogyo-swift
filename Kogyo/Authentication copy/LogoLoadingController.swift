//
//  OpenLoadingController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/24/24.
//

import UIKit
import WebKit

class LogoLoadingController: UIViewController {
    
    // MARK: - UI Components
    private let logoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    let webView: WKWebView = {
        let wV = WKWebView()
        return wV
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        guard let loadingAnimationUrl = URL(string: "https://gabrielcastilloh.github.io/codepen_animation/square_loader.html")
        else { return }
        webView.load(URLRequest(url: loadingAnimationUrl))
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
            
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            
            webView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 0),
            webView.heightAnchor.constraint(equalToConstant: 200),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
        ])
    }
}
