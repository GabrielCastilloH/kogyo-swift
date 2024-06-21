//
//  JobInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit
import FirebaseStorage

class JobInfoController: UIViewController {
    
    // MARK: - Variables
    var currentJob: Job
    var cf = CustomFunctions()
    var mediaData: [PlayableMediaView] = []
    
    
    // MARK: - UI Components
    var jobPhotosVideosView = JobPhotosVideosView()
    
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
    
    
    // MARK: - Life Cycle
    init(for job: Job, jobUID: String) {
        self.currentJob = job
        
        super.init(nibName: nil, bundle: nil)
        setupUI()
        
        FirestoreHandler.shared.fetchJobMedia(jobId: jobUID) { mediaData in
            // Use the mediaData array here
            self.mediaData = mediaData
            self.configureMediaViews()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupNavBar()
        self.setupUI()
        
        let dateNotFormatted = self.currentJob.dateAdded
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
        let formattedDate = dateFormatter.string(from: dateNotFormatted)
        self.dateAddedLabel.text = "Created on: \(formattedDate)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = self.currentJob.kind
    }
    
    private func setupUI() {
        self.view.addSubview(dateAddedLabel)
        dateAddedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let jobQuickInfoView = JobQuickInfoView(for: self.currentJob)
        let jobDescriptionView = JobDescriptionView(for: self.currentJob)
        
        let jobHelperInfoView = JobHelperInfoView(for: self.currentJob)
        
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
        
        self.view.addSubview(jobHelperInfoView)
        jobHelperInfoView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            jobPhotosVideosView.topAnchor.constraint(equalTo: jobDescriptionView.bottomAnchor),
            jobPhotosVideosView.heightAnchor.constraint(equalToConstant: 200),
            jobPhotosVideosView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobPhotosVideosView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            jobHelperInfoView.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 5),
            jobHelperInfoView.heightAnchor.constraint(equalToConstant: 250),
            jobHelperInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobHelperInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    
    // MARK: - Selectors & Functions
    // Its better to put the configure function here to keep everything in the view.
    func configureMediaViews() {
        for media in self.mediaData {
            self.jobPhotosVideosView.stackView.addArrangedSubview(media)
            
            NSLayoutConstraint.activate([
                media.widthAnchor.constraint(equalToConstant: 100),
            ])
        }
    }
}
