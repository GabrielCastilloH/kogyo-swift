//
//  CustomerTaskInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit
import AVKit
import FirebaseStorage

class CustomerTaskInfoController: UIViewController {
    
    // MARK: - Variables
    var selectedTask: TaskClass
    var cf = CustomFunctions()
    
    
    // MARK: - UI Components
    var jobHelperInfoView: JobHelperInfoView
    var taskPhotosVideosView = TaskPhotosVideosView()
    
    private let dateAddedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Loading..."
        return label
    }()
    
    lazy var reviewCompletionBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Review Completion", for: .normal)
        button.backgroundColor = UIColor(red: 0.10, green: 0.50, blue: 0.35, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapReviewCompletionBtn), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    init(for job: TaskClass, jobUID: String) {
        self.selectedTask = job
        self.jobHelperInfoView = JobHelperInfoView(for: job)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupNavBar()
        self.setupUI()
        
        
        // Configure media once the view loads.
        if let media = selectedTask.media {
            self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
        } else {
            Task {
                do {
                    let media = try await FirestoreHandler.shared.fetchJobMedia(taskId: self.selectedTask.taskUID, parentFolder: .jobs)
                    self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
                    
                    // Update DataManager
                    DataManager.shared.customerMyTasks[self.selectedTask.taskUID]?.media = media
                    
                } catch {
                    print("Failed to fetch media for the current task.")
                }
            }
        }
        
        let dateNotFormatted = self.selectedTask.dateAdded
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
        let formattedDate = dateFormatter.string(from: dateNotFormatted)
        self.dateAddedLabel.text = "Created on: \(formattedDate)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.toggleCompletionView()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        // Set title attributes for the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        self.navigationItem.title = self.selectedTask.kind

        // Create and customize the chat button
        let chatImage = UIImage(systemName: "message")?
            .withRenderingMode(.alwaysTemplate) // Use template mode for tinting
        let chatButton = UIBarButtonItem(image: chatImage, style: .plain, target: self, action: #selector(showChat))
        
        // Customize the appearance of the button
        chatButton.tintColor = .black // Set the icon color to black
        self.navigationItem.rightBarButtonItem = chatButton

        // Center-align the title and the button
        self.navigationController?.navigationBar.topItem?.titleView?.tintColor = .black
    }

    // Action method for the chat button
    @objc private func showChat() {
        let viewController = ChatViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func toggleCompletionView() {
        if self.selectedTask.completionStatus == .inReview {
            self.jobHelperInfoView.isHidden = true // This is called after setup ui.
            self.reviewCompletionBtn.isHidden = false
        } else {
            self.jobHelperInfoView.isHidden = false
            self.reviewCompletionBtn.isHidden = true
        }
    }
    
    private func setupUI() {
        self.view.addSubview(dateAddedLabel)
        dateAddedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let jobQuickInfoView = JobQuickInfoView(for: self.selectedTask)
        let jobDescriptionView = JobDescriptionView(for: self.selectedTask)
        jobHelperInfoView = JobHelperInfoView(for: self.selectedTask)
        
        self.view.addSubview(jobQuickInfoView)
        jobQuickInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        cf.createSeparatorView(for: self, with: separator1, under: jobQuickInfoView)
        
        self.view.addSubview(jobDescriptionView)
        jobDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(taskPhotosVideosView)
        taskPhotosVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2 = UIView()
        cf.createSeparatorView(for: self, with: separator2, under: taskPhotosVideosView)
        
        self.view.addSubview(jobHelperInfoView)
        jobHelperInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(reviewCompletionBtn)
        reviewCompletionBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateAddedLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            dateAddedLabel.heightAnchor.constraint(equalToConstant: 30),
            dateAddedLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dateAddedLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobQuickInfoView.topAnchor.constraint(equalTo: self.dateAddedLabel.bottomAnchor, constant: 10),
            jobQuickInfoView.heightAnchor.constraint(equalToConstant: 120),
            jobQuickInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobQuickInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobDescriptionView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 15),
            jobDescriptionView.heightAnchor.constraint(equalToConstant: 125),
            jobDescriptionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobDescriptionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            taskPhotosVideosView.topAnchor.constraint(equalTo: jobDescriptionView.bottomAnchor),
            taskPhotosVideosView.heightAnchor.constraint(equalToConstant: 120),
            taskPhotosVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            taskPhotosVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobHelperInfoView.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 0),
            jobHelperInfoView.heightAnchor.constraint(equalToConstant: 250),
            jobHelperInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobHelperInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            reviewCompletionBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200),
            reviewCompletionBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            reviewCompletionBtn.widthAnchor.constraint(equalToConstant: 200),
            reviewCompletionBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc func didTapReviewCompletionBtn() {
        let completeController = CustomerCompleteTaskController(selectedTaskUID: self.selectedTask.taskUID)
        completeController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(completeController, animated: true)
    }
}

extension CustomerTaskInfoController: PlayableMediaViewDelegate {
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
