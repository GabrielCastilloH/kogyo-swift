//
//  CompleteTaskController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/29/24.
//

import UIKit
import AVKit

class CompleteTaskController: UIViewController {

    // MARK: - Variables
    let selectedTask: TaskClass
    var idCounter = 0
    
    // MARK: - UI Components
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "To mark a task as complete, you must upload at least two photos or videos for verification, and the customer must approve the job. Kogyo ensures quality and satisfaction for both helpers and customers. If you believe the job is completed but the customer refuses to approve it, please submit a complaint through the 'Customer Support' option. Similarly, customers can file a complaint if they believe the job was done poorly or incurred unfair costs."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete Task", for: .normal)
        button.backgroundColor = UIColor(red: 0.27, green: 0.96, blue: 0.31, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    // MEDIA:
    var mediaData: [MediaView] = []
    var mediaScrollView: MediaScrollView
    let imagePickerController = UIImagePickerController()
    
    let mediaTitleView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.text = "Photos & Videos:"
        textView.textColor = .label
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        return textView
    }()
    
    private let mediaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 10
        return view
    }()


    // MARK: - Life Cycle
    init(selectedTask: TaskClass) {
        self.selectedTask = selectedTask
        self.mediaScrollView = MediaScrollView(media: self.mediaData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // MEDIA:
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.mediaTypes = ["public.image", "public.movie"]
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = "Complete Task"
        
        self.view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaTitleView)
        mediaTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaBackgroundView)
        mediaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaScrollView)
        mediaScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            mediaTitleView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            mediaTitleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaTitleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mediaTitleView.heightAnchor.constraint(equalToConstant: 70),
            
            mediaBackgroundView.topAnchor.constraint(equalTo: mediaTitleView.bottomAnchor, constant: 5),
            mediaBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mediaBackgroundView.heightAnchor.constraint(equalToConstant: 70),
            
            mediaScrollView.topAnchor.constraint(equalTo: mediaBackgroundView.topAnchor),
            mediaScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mediaScrollView.heightAnchor.constraint(equalToConstant: 70),
            
            completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            completeButton.widthAnchor.constraint(equalToConstant: 200),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc private func handleComplete() {
        // Setup an isComplete version of task view, where it is just awaiting an approval from a customer.
    }
    
    func presentMyTasksController() {
        if let myTasksController = self.navigationController?.viewControllers.first(where: { $0 is HelperMyTasksController }) {
            self.navigationController?.popToViewController(myTasksController, animated: true)
            AlertManager.showCanceledTaskAlert(on: myTasksController)
        }
    }
}

// MARK: - Media View Functions and Delegate
extension CompleteTaskController: MediaViewDelegate {
    
    public func addMedia(_ image: UIImage?, videoURL: URL? = nil) {
        var newMediaView = MediaView(with: image, and: self.idCounter)
        
        if videoURL != nil {
            newMediaView = MediaView(with: image, and: self.idCounter, videoURL: videoURL)
        }
        
        newMediaView.delegate = self
        self.mediaScrollView.stackView.insertArrangedSubview(newMediaView, at: 0)
        self.idCounter += 1
        
        NSLayoutConstraint.activate([
            newMediaView.topAnchor.constraint(equalTo: self.mediaScrollView.stackView.topAnchor),
            newMediaView.widthAnchor.constraint(equalToConstant: 70),
            newMediaView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        self.mediaData.append(newMediaView)
    }
    
    func didTapAddImage() {
        DispatchQueue.main.async { [ weak self ] in
            guard let self = self else { return }
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    
    func didTapX(at id: Int) {
        for media in self.mediaData {
            if media.id == id {
                media.removeFromSuperview()
            }
        }
    }
}

extension CompleteTaskController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as? String
        if mediaType == "public.image" {
            if let image = info[.originalImage] as? UIImage {
                self.addMedia(image)
            }
            
        } else if mediaType == "public.movie" {
            self.handleVideos(info)
        } else {
            print("DEBUG PRINT:", "Image was neither photos or videos.")
        }
        
        DispatchQueue.main.async { [ weak self ] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    // Handle Videos
    private func handleVideos(_ info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let videoURL = info[.mediaURL] as? URL else { return }
        
        AVAsset(url: videoURL).generateThumbnail { thumbnail in
            DispatchQueue.main.async {
                self.addMedia(thumbnail, videoURL: videoURL)
            }
        }
    }
}

