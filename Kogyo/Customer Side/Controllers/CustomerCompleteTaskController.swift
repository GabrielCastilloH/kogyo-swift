//
//  CustomerCompleteTaskController.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/2/24.
//

import UIKit
import AVKit
import FirebaseStorage

class CustomerCompleteTaskController: UIViewController {

    // MARK: - Variables
    var taskUID: String
    var selectedTask: TaskClass
    var helperInfo: JobHelperInfoView

    // MARK: - UI Components
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants().darkGrayColor
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Please review the completion media uploaded by the helper. If you are satisfied with the work, confirm the completion to release the payment. If there are any issues, you can contact support."
        label.numberOfLines = 0
        return label
    }()
    
    let helperInfoTitle = CustomFunctions.shared.createFormLabel(for: "Helper Information:")
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Completion", for: .normal)
        button.backgroundColor = UIColor(red: 0.10, green: 0.50, blue: 0.35, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        return button
    }()
    
    // REVIEW MEDIA
    var taskPhotosVideosView = TaskPhotosVideosView()

    // MARK: - Life Cycle
    init(selectedTaskUID: String) {
        self.taskUID = selectedTaskUID
        self.selectedTask = DataManager.shared.customerMyTasks[self.taskUID]!
        self.helperInfo = JobHelperInfoView(for: self.selectedTask)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let media = selectedTask.completionMedia {
            self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
        } else {
            Task {
                do {
                    let media = try await FirestoreHandler.shared.fetchJobMedia(taskId: self.selectedTask.taskUID, parentFolder: .completion)
                    self.taskPhotosVideosView.configureMediaViews(mediaData: media, delegate: self)
                    
                    DataManager.shared.customerMyTasks[self.selectedTask.taskUID]?.completionMedia = media
                } catch {
                    print("Failed to fetch media for the current task.")
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = "Complete Task"
        
        self.view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(taskPhotosVideosView)
        taskPhotosVideosView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(helperInfoTitle)
        helperInfoTitle.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(helperInfo)
        helperInfo.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            taskPhotosVideosView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 30),
            taskPhotosVideosView.heightAnchor.constraint(equalToConstant: 120),
            taskPhotosVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            taskPhotosVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
            helperInfoTitle.topAnchor.constraint(equalTo: taskPhotosVideosView.bottomAnchor, constant: 20),
            helperInfoTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            helperInfoTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            helperInfoTitle.heightAnchor.constraint(equalToConstant: 30),
            
            helperInfo.topAnchor.constraint(equalTo: helperInfoTitle.bottomAnchor, constant: 0),
            helperInfo.heightAnchor.constraint(equalToConstant: 200),
            helperInfo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            helperInfo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: self.helperInfo.bottomAnchor, constant: 40),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc private func handleConfirm() {
        let userUID = selectedTask.userUID
        let taskUID = selectedTask.taskUID
        
        Task {
            do {
                try await FirestoreHandler.shared.updateTaskCompletion(userUID: userUID, taskUID: taskUID, completionStatus: .complete)
                
                // Update DataManager
                self.selectedTask.completionStatus = .complete
                DataManager.shared.customerMyTasks[self.taskUID] = nil
                DataManager.shared.customerOldTasks[self.taskUID] = self.selectedTask
                
                // Pop to home
                if let tasksController = self.navigationController?.viewControllers.first(where: { $0 is CustomerMyTasksController }) {
                    // Pop to CustomerHomeController if found
                    self.navigationController?.popToViewController(tasksController, animated: true)
                    AlertManager.showBasicAlert(on: tasksController, title: "Task Finished!", message: "The task was successfully marked as complete. Click on the history icon on the top right of the screen to see completed tasks.")
                }
                
            } catch {
                AlertManager.showBasicAlert(on: self, title: "Failed", message: "The task could not be marked as complete. Please check your internet and try again.")
            }
        }
    }
}


// MARK: - Media View Functions and Delegate
extension CustomerCompleteTaskController: PlayableMediaViewDelegate {
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
