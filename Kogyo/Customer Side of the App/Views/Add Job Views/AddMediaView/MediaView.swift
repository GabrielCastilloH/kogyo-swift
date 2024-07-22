//
//  MediaView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/17/24.
//

import UIKit

protocol MediaViewDelegate {
    func didTapX(at id: Int)
    func didTapAddImage()
}

class MediaView: UIView {
    // MARK: - Variables
    var media: UIImage?
    var id: Int
    var isHighlightedViewHidden = true
    var videoURL: URL?
    
    var delegate: MediaViewDelegate?
    
    
    // MARK: - UI Components
    // EMPTY:
    private let borderView = CustomDashedView()
    
    private let addImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = .black
        return iv
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // NOT EMPTY:
    public let mediaImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemPink
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    private let highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkGrayColor.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var touchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(mediaViewTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
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
    init(with image: UIImage?, and id: Int, videoURL: URL? = nil) {
        self.media = image
        self.id = id
        self.videoURL = videoURL
        
        super.init(frame: .zero)
        
        if self.media != nil {
            mediaImageView.image = self.media
            self.setupUI()
                
            if videoURL != nil {
                self.videoIcon.isHidden = false
            }
            
        } else {
            self.setupEmptyUI()
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
        
        self.addSubview(highlightedView)
        highlightedView.translatesAutoresizingMaskIntoConstraints = false
        highlightedView.isHidden = true
        
        self.addSubview(touchButton)
        touchButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.isHidden = true
        
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            mediaImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            mediaImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            mediaImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            highlightedView.topAnchor.constraint(equalTo: mediaImageView.topAnchor),
            highlightedView.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            highlightedView.leadingAnchor.constraint(equalTo: mediaImageView.leadingAnchor),
            highlightedView.trailingAnchor.constraint(equalTo: mediaImageView.trailingAnchor),
            
            videoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            videoIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            videoIcon.heightAnchor.constraint(equalToConstant: 15),
            videoIcon.widthAnchor.constraint(equalToConstant: 15),
            
            touchButton.topAnchor.constraint(equalTo: mediaImageView.topAnchor),
            touchButton.bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor),
            touchButton.leadingAnchor.constraint(equalTo: mediaImageView.leadingAnchor),
            touchButton.trailingAnchor.constraint(equalTo: mediaImageView.trailingAnchor),
            
            xButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            xButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            xButton.heightAnchor.constraint(equalToConstant: 20),
            xButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupEmptyUI() {
        self.addSubview(addImageView)
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addImageButton)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addImageView.heightAnchor.constraint(equalToConstant: 30),
            addImageView.widthAnchor.constraint(equalToConstant: 30),
            
            borderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            addImageButton.topAnchor.constraint(equalTo: borderView.topAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
            addImageButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            addImageButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func mediaViewTapped() {
        if self.isHighlightedViewHidden == false {
            self.highlightedView.isHidden = true
            self.xButton.isHidden = true
            self.isHighlightedViewHidden = true
        } else {
            self.highlightedView.isHidden = false
            self.isHighlightedViewHidden = false
            self.xButton.isHidden = false
        }
    }
    
    @objc func addImageButtonTapped() {
        self.delegate?.didTapAddImage()
    }
    
    @objc func xButtonTapped() {
        self.delegate?.didTapX(at: self.id)
    }
}
