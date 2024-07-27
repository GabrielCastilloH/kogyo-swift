//
//  AvailableTaskInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 7/11/24.
//

import UIKit
import AVKit
import FirebaseStorage

class AvailableTaskInfoController: UIViewController {
    // Info about an available task. Helpers accept tasks through this screen.
    
    // MARK: - Variables
    var selectedTask: TaskClass
    var cf = CustomFunctions()
    var mediaData: [PlayableMediaView] = []
    
    
    // MARK: - UI Components
    var jobPhotosVideosView = TaskPhotosVideosView()
    
    private let postedOnLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Loading..."
        return label
    }()
    
    private lazy var acceptJobButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Accept Job", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = Constants().lightBlueColor
        button.addTarget(self, action: #selector(didTapAcceptJob), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    init(for job: TaskClass, taskUID: String) {
        self.selectedTask = job
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
        self.mediaData = DataManager.shared.helperAvailableTasks[self.selectedTask.taskUID]!.media
        self.configureMediaViews()
        
        let dateNotFormatted = self.selectedTask.dateAdded
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
        let formattedDate = dateFormatter.string(from: dateNotFormatted)
        self.postedOnLabel.text = "Posted on: \(formattedDate)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = self.selectedTask.kind
    }
    
    private func setupUI() {
        self.view.addSubview(postedOnLabel)
        postedOnLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let jobQuickInfoView = JobQuickInfoView(for: self.selectedTask)
        let jobDescriptionView = JobDescriptionView(for: self.selectedTask)
        let taskRequiredEquipmentView = TaskRequiredEquipmentView(for: self.selectedTask)
        
        self.view.addSubview(jobQuickInfoView)
        jobQuickInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        cf.createSeparatorView(for: self, with: separator1, under: jobQuickInfoView)
        
        self.view.addSubview(jobDescriptionView)
        jobDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(jobPhotosVideosView)
        jobPhotosVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2 = UIView()
        cf.createSeparatorView(for: self, with: separator2, under: jobPhotosVideosView)
        
        self.view.addSubview(taskRequiredEquipmentView)
        taskRequiredEquipmentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(acceptJobButton)
        acceptJobButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postedOnLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            postedOnLabel.heightAnchor.constraint(equalToConstant: 30),
            postedOnLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            postedOnLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobQuickInfoView.topAnchor.constraint(equalTo: self.postedOnLabel.bottomAnchor, constant: 10),
            jobQuickInfoView.heightAnchor.constraint(equalToConstant: 120),
            jobQuickInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobQuickInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobDescriptionView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 15),
            jobDescriptionView.heightAnchor.constraint(equalToConstant: 125),
            jobDescriptionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobDescriptionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobPhotosVideosView.topAnchor.constraint(equalTo: jobDescriptionView.bottomAnchor),
            jobPhotosVideosView.heightAnchor.constraint(equalToConstant: 120),
            jobPhotosVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobPhotosVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            taskRequiredEquipmentView.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 15),
            taskRequiredEquipmentView.heightAnchor.constraint(equalToConstant: 120),
            taskRequiredEquipmentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            taskRequiredEquipmentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            acceptJobButton.topAnchor.constraint(equalTo: taskRequiredEquipmentView.bottomAnchor, constant: 5),
            acceptJobButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            acceptJobButton.heightAnchor.constraint(equalToConstant: 50),
            acceptJobButton.widthAnchor.constraint(equalToConstant: 180),
        ])
    }
    
    
    // MARK: - Selectors & Functions
    @objc private func didTapAcceptJob() {
        let helperUID = DataManager.shared.currentUser!.userUID
        FirestoreHandler.shared.assignHelper(helperUID, toJob: self.selectedTask.taskUID, forUser: self.selectedTask.userUID) { error in
            if let error = error {
                print("Error assigning helper: \(error.localizedDescription)")
            } else {
                self.presentMyTasksController()
            }
        }
    }
    
    func presentMyTasksController() {
        if let homeController = self.navigationController?.viewControllers.first(where: { $0 is HelperDashboardController }) {
            // Pop to CustomerHomeController if found
            self.navigationController?.popToViewController(homeController, animated: true)
            AlertManager.showTaskAcceptedAlert(on: homeController)
        }
    }
    
    // Its better to put the configure function here to keep everything in the view.
    func configureMediaViews() {
        for media in self.mediaData {
            media.delegate = self
            self.jobPhotosVideosView.stackView.addArrangedSubview(media)
            
            NSLayoutConstraint.activate([
                media.widthAnchor.constraint(equalToConstant: 100),
            ])
        }
    }
}

extension AvailableTaskInfoController: PlayableMediaViewDelegate {
    // TODO: Move this to custom functions.
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
