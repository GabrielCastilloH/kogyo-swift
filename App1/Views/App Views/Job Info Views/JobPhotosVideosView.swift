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
//    var mediaData: [PlayableMediaView]
    
    // MARK: - UI Components
    private let mediaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let navbarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Scroll View:
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    
    // MARK: - Life Cycle
    init() {
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
        
        self.addSubview(mediaBackgroundView)
        mediaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoVideoTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            photoVideoTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),

            mediaBackgroundView.topAnchor.constraint(equalTo: photoVideoTitle.bottomAnchor, constant: 5),
            mediaBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            mediaBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            mediaBackgroundView.heightAnchor.constraint(equalToConstant: 100),
            
            scrollView.topAnchor.constraint(equalTo: mediaBackgroundView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mediaBackgroundView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: mediaBackgroundView.leadingAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: mediaBackgroundView.trailingAnchor, constant: -5),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }

    // MARK: - Selectors & Functions
}
