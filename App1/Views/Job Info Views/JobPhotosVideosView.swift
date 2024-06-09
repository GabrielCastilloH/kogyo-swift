//
//  JobPhotosVideosView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class JobPhotosVideosView: UIView {
    // MARK: - Variables
    let cf = CustomFunctions()
    
    
    // MARK: - UI Components
    
    private let photoVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        return view
    }()
    
    
    // MARK: - Life Cycle
    init(for job: Job) {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let photoVideoTitle = cf.createFormLabel(for: "Photos & Videos")
        
        self.addSubview(photoVideoTitle)
        photoVideoTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(photoVideoView)
        photoVideoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoVideoTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            photoVideoTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            photoVideoView.topAnchor.constraint(equalTo: photoVideoTitle.bottomAnchor, constant: 5),
            photoVideoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoVideoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoVideoView.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }

    // MARK: - Selectors

}
