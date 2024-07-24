//
//  PhotoViewController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/22/24.
//

import UIKit

class PhotoViewController: UIViewController {
    // View presented when a photo is clicked on the media view.
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    
    // MARK: - Life Cycle
    init(thumbnail: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        
        self.imageView.image = thumbnail
        self.navigationItem.title = "Photo"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if Int(self.imageView.image?.size.width ?? 0) > Int(self.imageView.image?.size.height ?? 0) {
            // The width is larger than the height (landscape)
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 500),
            ])
        } else {
            // The height is larger than the width (portrait)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 105),
                imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
                imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 300),
            ])
        }
    }
}
