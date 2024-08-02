//
//  CompleteTaskController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 7/29/24.
//

import UIKit
import AVKit
import FirebaseStorage

class CompleteTaskController: UIViewController {

    // MARK: - Variables
    var taskUID: String
    var selectedTask: TaskClass
    var idCounter = 0
    // MEDIA:
    var mediaData: [MediaView] = []
    var mediaPlayableViews: [PlayableMediaView] = []
    var mediaScrollView: MediaScrollView!
    let imagePickerController = UIImagePickerController()
    let mediaTitle = CustomFunctions.shared.createFormLabel(for: "Photos & Videos")
    
    // REVIEW MEDIA
    var taskPhotosVideosView = TaskPhotosVideosView()
    
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
        button.backgroundColor = UIColor(red: 0.10, green: 0.50, blue: 0.35, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Completion", for: .normal)
        button.backgroundColor = UIColor(red: 0.96, green: 0.27, blue: 0.31, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    // MEDIA:
    private let mediaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 10
        return view
    }()

    // MARK: - Life Cycle
    init(selectedTaskUID: String) {
        self.taskUID = selectedTaskUID
        self.selectedTask = DataManager.shared.helperMyTasks[self.taskUID]!
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Configure media once the view loads.
        if let media = selectedTask.completionMedia {
            self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
        } else {
            Task {
                do {
                    let media = try await FirestoreHandler.shared.fetchJobMedia(taskId: self.selectedTask.taskUID, parentFolder: .completion)
                    self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
                    
                    // Update DataManager
                    DataManager.shared.helperMyTasks[self.selectedTask.taskUID]?.completionMedia = media
                    
                } catch {
                    print("Failed to fetch media for the current task.")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // MEDIA:
        self.mediaScrollView = MediaScrollView(media: self.mediaData)
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = false
        self.imagePickerController.mediaTypes = ["public.image", "public.movie"]
        self.addMedia(nil)
        
        self.setupUI()
        self.toggleReviewUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        self.navigationItem.title = "Complete Task"
        
        self.view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaTitle)
        mediaTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaBackgroundView)
        mediaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaScrollView)
        mediaScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(taskPhotosVideosView)
        taskPhotosVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            mediaTitle.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            mediaTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mediaTitle.heightAnchor.constraint(equalToConstant: 30),
            
            mediaBackgroundView.topAnchor.constraint(equalTo: mediaTitle.bottomAnchor, constant: 10),
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
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            
            taskPhotosVideosView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            taskPhotosVideosView.heightAnchor.constraint(equalToConstant: 120),
            taskPhotosVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            taskPhotosVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
            cancelButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 200),
            cancelButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func toggleReviewUI() {
        if self.selectedTask.completionStatus == .inReview {
            // If task is inReview: Hide everything
            self.mediaTitle.isHidden = true
            self.mediaScrollView.isHidden = true
            self.mediaBackgroundView.isHidden = true
            self.completeButton.isHidden = true
            self.taskPhotosVideosView.isHidden = false
            self.cancelButton.isHidden = false
        } else {
            // If task is not inReview show everything, delete review media.
            self.mediaTitle.isHidden = false
            self.mediaScrollView.isHidden = false
            self.mediaBackgroundView.isHidden = false
            self.completeButton.isHidden = false
            
            self.taskPhotosVideosView.isHidden = true
            self.cancelButton.isHidden = true
        }
    }
    
    // MARK: - Selectors & Functions
    @objc private func handleComplete() {
        if self.mediaData.count <= 2 {
            AlertManager.showBasicAlert(on: self, title: "Media Required", message: "You must upload at least 2 photos or videos as proof of task completion.")
        } else {
            
            // Call uploadMedia firestore function. Upload it to: "completion"
            let mediaArray = FirestoreHandler.shared.uploadMedia(taskUID: selectedTask.taskUID, parentFolder: .completion, mediaData: mediaData)
            
            self.selectedTask.completionMedia = mediaArray // Update the completionMedia on the TaskClass object.
            self.selectedTask.completionStatus = .inReview
            self.mediaPlayableViews = mediaArray
            DataManager.shared.customerMyTasks[selectedTask.taskUID] = self.selectedTask // update DataManager.
            
            // Change status in Firebase to in review.
            let userUID = selectedTask.userUID
            let taskUID = selectedTask.taskUID
            
            Task {
                do {
                    try await FirestoreHandler.shared.updateTaskCompletion(userUID: userUID, taskUID: taskUID, completionStatus: .inReview)
                    AlertManager.showBasicAlert(on: self, title: "Task Marked as Complete", message: "The task was successfully marked as complete.")
                    self.toggleReviewUI()
                } catch {
                    AlertManager.showBasicAlert(on: self, title: "Failed", message: "The task could not be marked as complete. Please check your internet and try again.")
                }
            }
        }
    }
    
    @objc private func handleCancel() {
        let userUID = selectedTask.userUID
        let taskUID = selectedTask.taskUID
        
        Task {
            do {
                try await FirestoreHandler.shared.updateTaskCompletion(userUID: userUID, taskUID: taskUID, completionStatus: .notComplete)
                AlertManager.showBasicAlert(on: self, title: "Task Marked as Not Complete", message: "The task was successfully marked as not complete.")
                
                // Delete data & update UI
                try await FirestoreHandler.shared.deleteMedia(taskId: self.selectedTask.taskUID, parentFolder: .completion)
                
                // update DataManager.
                self.selectedTask.completionStatus = .notComplete
                self.selectedTask.completionMedia = nil
                DataManager.shared.helperMyTasks[selectedTask.taskUID] = self.selectedTask
                
                self.toggleReviewUI()
            } catch {
                AlertManager.showBasicAlert(on: self, title: "Failed", message: "The task could not be marked as not complete. Please check your internet and try again.")
            }
        }
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
        DispatchQueue.main.async { [weak self] in
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
        
        DispatchQueue.main.async { [weak self] in
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

extension CompleteTaskController: PlayableMediaViewDelegate {
    func didTapMedia(thumbnail: UIImage?, videoUID: String?) {
        // Play video or zoom in on photo if it is tapped by the user.
        if videoUID == nil {
            let viewController = PhotoViewController(thumbnail: thumbnail)
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            // Fetch video from Firestore and present AV controller.
            let videoFileName = "\(videoUID!).mov"
            let videoRef = Storage.storage().reference().child("jobs/\(self.selectedTask.taskUID)/\(videoFileName)")
            
            // Fetch the download URL
            videoRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching video URL: \(error.localizedDescription)")
                    return
                }
                
                guard let url = url else {
                    print("Error: Video URL is nil")
                    return
                }
                
                // Present the video using AVPlayerViewController
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                // Ensure the player starts playing when the view appears
                playerViewController.player?.play()
                
                // Present the AVPlayerViewController
                DispatchQueue.main.async {
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                    }
                }
            }
        }
    }
}

