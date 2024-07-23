//
//  CreateJobController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit
import FirebaseAuth
import Photos
import FirebaseStorage

class CreateJobController: UIViewController {
    // Responsible for creating a new job.
    // Also responsible for the addition of photos and videos.
    
    
    // MARK: - Variables
    var jobKind: String
    var keyboardHeight: CGFloat = 300
    var cf = CustomFunctions()
    var idCounter = 0
    
    // Media Scroll View:
    var mediaData: [MediaView] = []
    var mediaScrollView: MediaScrollView
    let imagePickerController = UIImagePickerController()
    
    // MARK: - UI Components
    let jobKindView: JobKindFormView
    let descriptionFormView = DescriptionFormView()
    
    let mediaTitleView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.text = "Photos & Videos:"
        textView.textColor = .label
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        return textView
    }()
    
    public let jobDateTimeView = JobDateTimeView()
    let jobHoursView = JobHoursView()
    let addEquipmentFormView = AddEquipmentFormView()
    let jobPaymentView = JobPaymentView()
    
    private lazy var submitJobBtn: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Submit Task", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = Constants().lightBlueColor
        button.addTarget(self, action: #selector(didTapSubmitJob), for: .touchUpInside)
        return button
    }()
    
    // Media view:
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
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        self.submitJobBtn.isUserInteractionEnabled = true
        self.submitJobBtn.backgroundColor = Constants().lightBlueColor
        self.setupNavbar()
    }
    
    init(kind: String) {
        self.jobKindView = JobKindFormView(kind: kind)
        self.jobKind = kind
        
        self.mediaScrollView = MediaScrollView(media: self.mediaData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        
        self.jobDateTimeView.delegate = self
        
        self.setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        addMedia(nil)
    }
    
    // MARK: - UI Setup
    private func setupNavbar() {
        self.view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationItem.title = "Create a New Task"
    }
    
    private func setupUI() {
        self.view.addSubview(navbarBackgroundView)
        navbarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(jobKindView)
        jobKindView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        cf.createSeparatorView(for: self, with: separator1, under: jobKindView)
        
        self.view.addSubview(descriptionFormView)
        descriptionFormView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaTitleView)
        mediaTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaBackgroundView)
        mediaBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaScrollView)
        mediaScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(jobDateTimeView)
        jobDateTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator3 = UIView()
        cf.createSeparatorView(for: self, with: separator3, under: jobDateTimeView)
        
        self.view.addSubview(jobHoursView)
        jobHoursView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addEquipmentFormView)
        addEquipmentFormView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator4 = UIView()
        cf.createSeparatorView(for: self, with: separator4, under: addEquipmentFormView)
        
        self.view.addSubview(jobPaymentView)
        jobPaymentView.translatesAutoresizingMaskIntoConstraints = false
        jobPaymentView.delegate = self
        
        let separator5 = UIView()
        cf.createSeparatorView(for: self, with: separator5, under: jobPaymentView)
        
        self.view.addSubview(submitJobBtn)
        submitJobBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navbarBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: keyboardHeight - 200),
            navbarBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navbarBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navbarBackgroundView.heightAnchor.constraint(equalToConstant: 250),
            
            jobKindView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            jobKindView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobKindView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobKindView.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionFormView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 15),
            descriptionFormView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            descriptionFormView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            descriptionFormView.heightAnchor.constraint(equalToConstant: 100),
            
            mediaTitleView.topAnchor.constraint(equalTo: descriptionFormView.bottomAnchor, constant: 0),
            mediaTitleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaTitleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mediaTitleView.heightAnchor.constraint(equalToConstant: 70),
            
            mediaBackgroundView.topAnchor.constraint(equalTo: descriptionFormView.bottomAnchor, constant: 35),
            mediaBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mediaBackgroundView.heightAnchor.constraint(equalToConstant: 70),
            
            mediaScrollView.topAnchor.constraint(equalTo: descriptionFormView.bottomAnchor, constant: 35),
            mediaScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            mediaScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            mediaScrollView.heightAnchor.constraint(equalToConstant: 70),
            
            
            jobDateTimeView.topAnchor.constraint(equalTo: mediaBackgroundView.bottomAnchor, constant: 15),
            jobDateTimeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobDateTimeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobDateTimeView.heightAnchor.constraint(equalToConstant: 60),
            
            jobHoursView.topAnchor.constraint(equalTo: separator3.bottomAnchor, constant: 15),
            jobHoursView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobHoursView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobHoursView.heightAnchor.constraint(equalToConstant: 30),
            
            addEquipmentFormView.topAnchor.constraint(equalTo: jobHoursView.bottomAnchor, constant: 5),
            addEquipmentFormView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            addEquipmentFormView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            addEquipmentFormView.heightAnchor.constraint(equalToConstant: 15),
            
            jobPaymentView.topAnchor.constraint(equalTo: separator4.bottomAnchor, constant: 15),
            jobPaymentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobPaymentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobPaymentView.heightAnchor.constraint(equalToConstant: 75),
            
            submitJobBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -110),
            submitJobBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            submitJobBtn.heightAnchor.constraint(equalToConstant: 50),
            submitJobBtn.widthAnchor.constraint(equalToConstant: 180),
        ])
        
        view.bringSubviewToFront(navbarBackgroundView)
        navbarBackgroundView.isHidden = true
    }
    
    // MARK: - Selectors & Functions
    private func presentLoadingScreen(jobUID: String, userId: String) {
        let loadingScreenController = LoadingScreenController(jobId: jobUID, userId: userId)
        self.navigationController?.pushViewController(loadingScreenController, animated: true)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func didTapSubmitJob() {
        let dateAdded = Date()
        let kind = self.jobKindView.pickerTextField.text ?? ""
        let description = self.descriptionFormView.descriptionTextView.text ?? ""
        let dateTime = self.jobDateTimeView.datePicker.date
        let expectedHours = Int(self.jobHoursView.pickerTextField.text ?? "") ?? 0
        let location = self.jobDateTimeView.addressLabel.text ?? "Click to set location"
        let payment = Int(self.jobPaymentView.paymentTextField.text ?? "") ?? 0
        
        if kind == "" || description == "" || expectedHours == 0 || location == "" || payment == 0 || location == "Click to set location" {
            AlertManager.showMissingJobInfoAlert(on: self)
            
        } else {
            let jobData: [String: Any] = [
                "dateAdded": dateAdded,
                "kind": kind,
                "description": description,
                "dateTime": dateTime,
                "expectedHours": expectedHours,
                "location": location,
                "payment": payment,
            ]
            
            guard let userUID = Auth.auth().currentUser?.uid else { return }
            FirestoreHandler.shared.addJob(with: jobData, for: userUID) { result in
                switch result {
                case .success(let jobUID):
                    // The job was added successfully (no media yet).
                    self.presentLoadingScreen(jobUID: jobUID, userId: userUID)
                    
                    var mediaArray: [PlayableMediaView] = []
                    
                    for media in self.mediaData {
                        if media != self.mediaData[0] {
                            
                            if let videoURL = media.videoURL {
                                // Upload video to database.
                                let videoToUploadURL = videoURL
                                let videoUID = FirestoreHandler.shared.uploadVideoToFirebase(parentFolder: "jobs", containerId: jobUID, videoURL: videoToUploadURL, thumbnail: media.mediaImageView.image)
                                
                                // Append media view to media in DataManager
                                let playableMediaView = PlayableMediaView(with: media.media, videoUID: videoUID)
                                mediaArray.append(playableMediaView)
                                
                            } else {
                                // Upload image to database.
                                let imageToUpload = media.mediaImageView.image
                                FirestoreHandler.shared.uploadImageToFirebase(parentFolder: "jobs", containerId: jobUID, image: imageToUpload!)
                                
                                // Append media view to media in DataManager.
                                let playableMediaView = PlayableMediaView(with: media.media, videoUID: nil)
                                mediaArray.append(playableMediaView)
                            }
                        }
                    }
                    
                    DataManager.shared.currentJobs[jobUID] = TaskClass(
                        jobUID: jobUID,
                        dateAdded: dateAdded,
                        kind: kind,
                        description: description,
                        dateTime: dateTime,
                        expectedHours: expectedHours,
                        location: location,
                        payment: payment,
                        helperUID: nil,
                        media: mediaArray,
                        equipment: []
                    )
                    
                case .failure(let error):
                    print("Error adding job: \(error.localizedDescription)")
                }
            }
            
            self.submitJobBtn.isUserInteractionEnabled = false
            self.submitJobBtn.backgroundColor = Constants().lightGrayColor.withAlphaComponent(0.7)
        }
    }
}

extension CreateJobController: JobPaymentViewDelegate {
    func paymentTextFieldPressed() {
        self.navigationController?.navigationBar.backgroundColor = .white
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.4,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = -self.keyboardHeight + 50
                })
            
            UIView.transition(
                with: self.view, duration: 0.4,
                options: .transitionCrossDissolve,
                animations: {
                    self.navbarBackgroundView.isHidden = false
                })
        }
    }
    
    func paymentTextFieldDismissed() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.1,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = 0
                    self.navbarBackgroundView.isHidden = true
                })
        }
    }
}

extension CreateJobController: JobDateTimeViewDelegate {
    func pressedLocationButton() {
        let addressPickerController = MapController()
        addressPickerController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(addressPickerController, animated: true)
    }
}

// MARK: - Media View Functions and Delegate
extension CreateJobController: MediaViewDelegate {
    
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

extension CreateJobController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
                self.addMedia(thumbnail, videoURL: videoURL) // Make sure that you add a play button on top left corner so they know its a video.
            }
        }
    }
    
}
