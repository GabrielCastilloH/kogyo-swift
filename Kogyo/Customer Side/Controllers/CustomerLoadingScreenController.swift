//
//  CustomerLoadingScreenController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/9/24.
//

import UIKit
import WebKit
import Firebase
// There are no good raw swift loading animations. I don't want to install third party plug ins.
// And gifs are memory intensive. I will try using a webkit view and a raw css animation.

class CustomerLoadingScreenController: UIViewController {
    // Loading screen while user waits for someone to accept their job.

    // MARK: - Variables
    var jobId: String
    var userId: String
    
    private var taskListener: ListenerRegistration?
    
    // MARK: - UI Components
    let webView: WKWebView = {
        let wV = WKWebView()
        return wV
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.text = "If no helpers are found within 30 minutes, please try changing your price."
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var editJobBtn: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Edit Task", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = Constants().lightBlueColor
        button.addTarget(self, action: #selector(didTapEditJob), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupNavBar()
        self.setupUI()
        
        // Setup your view here
        listenForJobUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove the listener when the view disappears to avoid memory leaks
        self.tabBarController?.tabBar.isHidden = false
        taskListener?.remove()
    }
    
    // MARK: - UI Setup
    init(jobId: String, userId: String) {
        print("job ID:", jobId)
        self.jobId = jobId
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true

        self.navigationItem.title = "Looking for a Helper"
    }
    
    private func setupUI() {
        guard let loadingAnimationUrl = URL(string: "https://gabrielcastilloh.github.io/codepen_animation/redirecting_loader.html")
        else { return }
        webView.load(URLRequest(url: loadingAnimationUrl))
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(editJobBtn)
        editJobBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            webView.heightAnchor.constraint(equalToConstant: 500),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 30),
            loadingLabel.widthAnchor.constraint(equalToConstant: 300),
            loadingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            editJobBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -140),
            editJobBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            editJobBtn.heightAnchor.constraint(equalToConstant: 50),
            editJobBtn.widthAnchor.constraint(equalToConstant: 180),
        ])
    }
    
    // MARK: - Selectors & Functions
    
    private func listenForJobUpdates() {
        let db = Firestore.firestore()
        let jobRef = db.collection("users").document(userId).collection("jobs").document(self.jobId)

        taskListener = jobRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error listening for job updates: \(error.localizedDescription)")
                return
            }

            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                print("Document does not exist")
                return
            }

            if let helperUID = data["helperUID"] as? String {

                Task {
                    if let newTask = try? await FirestoreHandler.shared.fetchCustomerTask(taskUID: self.jobId) {
                        DataManager.shared.customerMyTasks[self.jobId] = newTask

                        if DataManager.shared.helpers[helperUID] == nil {
                            let newHelper = try? await FirestoreHandler.shared.fetchHelper(for: helperUID)
                            DataManager.shared.helpers[helperUID] = newHelper
                        }
                        self.presentCurrentJobsController()
                    }
                }
            }
        }
    }
    
    func popToCreateJob() {
        if let createJobVC = self.navigationController?.viewControllers.filter({ $0 is CustomerCreateTaskController }).first { 
            self.navigationController?.popToViewController(createJobVC, animated: true)
        }
    }
    
    func presentCurrentJobsController() {
        if let homeController = self.navigationController?.viewControllers.first(where: { $0 is CustomerHomeController }) {
            // Pop to CustomerHomeController if found
            self.navigationController?.popToViewController(homeController, animated: true)
            AlertManager.showJobAddedAlert(on: homeController)
        }
    }
    
    @objc func didTapEditJob() {
        Task {
            do {
                try await FirestoreHandler.shared.deleteTask(
                    taskUID: self.jobId,
                    userUID: self.userId,
                    collection: .tasks
                )
                self.popToCreateJob()
            } catch {
                print("Error Removing the Task From Database: \(error.localizedDescription)")
            }
        }
    }
}
