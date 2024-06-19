//
//  PlayableMediaView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/18/24.
//

import UIKit

protocol PlayableMediaViewDelegate {
    func didTapMedia()
}

class PlayableMediaView: UIView {
    // MARK: - Variables
    var thumbnail: UIImage?
    var videoUID: String?
    
    var delegate: PlayableMediaViewDelegate?
    
    
    // MARK: - UI Components
    public let mediaImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemPink
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var touchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(mediaViewTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var videoIcon: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white.withAlphaComponent(0.9)
        iv.image = UIImage(systemName: "play.fill")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    // MARK: - Life Cycle
    init(with image: UIImage?, videoUID: String? = nil) {
        self.thumbnail = image
        self.videoUID = videoUID
        
        super.init(frame: .zero)
        
        if self.thumbnail != nil {
            mediaImageView.image = self.thumbnail
            self.setupUI()
            
            if videoUID != nil {
                self.videoIcon.isHidden = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(mediaImageView)
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(videoIcon)
        videoIcon.translatesAutoresizingMaskIntoConstraints = false
        videoIcon.isHidden = true
        
        self.addSubview(touchButton)
        touchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            mediaImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            mediaImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            mediaImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            videoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            videoIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            videoIcon.heightAnchor.constraint(equalToConstant: 15),
            videoIcon.widthAnchor.constraint(equalToConstant: 15),
            
            touchButton.topAnchor.constraint(equalTo: mediaImageView.topAnchor),
            touchButton.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            touchButton.leadingAnchor.constraint(equalTo: mediaImageView.leadingAnchor),
            touchButton.trailingAnchor.constraint(equalTo: mediaImageView.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func mediaViewTapped() {
        self.delegate?.didTapMedia()
        print("zoom in on the image, or play the video here.")
    }
}
