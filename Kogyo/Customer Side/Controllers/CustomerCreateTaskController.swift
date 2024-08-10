//
//  CustomerCreateTaskController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit
import FirebaseAuth
import Photos
import FirebaseStorage
import StripePaymentSheet


class CustomerCreateTaskController: UIViewController {
    // Responsible for creating a new job.
    // Also responsible for the addition of photos and videos.
    
    // MARK: - Variables
    var jobKind: String
    var keyboardHeight: CGFloat = 300
    var cf = CustomFunctions()
    var idCounter = 0
    
    var paymentSheet: PaymentSheet?
    let backendCheckoutUrl = URL(string: "http://127.0.0.1:4242/payment-sheet")! // Your backend endpoint
    
    // Media Scroll View:
    var mediaData: [MediaView] = []
    var mediaScrollView: MediaScrollView
    let imagePickerController = UIImagePickerController()
    
    // Materials
    var materials = [(String, Int, Float)]()
    let materialsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Constants().darkWhiteColor
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 3
        tableView.layer.borderColor = Constants().darkWhiteColor.cgColor
        return tableView
    }()
    
    // MARK: - UI Components
    let jobKindView: JobKindFormView
    let descriptionFormView = DescriptionFormView()
    lazy var payButton : UIBarButtonItem = {
        let barBtn = UIBarButtonItem(title: "Pay", style: .plain, target: self, action: #selector(didTapPay))
        barBtn.tintColor = .gray
        barBtn.isEnabled = false
        return barBtn
    }()
    
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
    
    // Media view:
    private let mediaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants().darkWhiteColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
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
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        
        self.jobDateTimeView.delegate = self
        self.addEquipmentFormView.delegate = self
        
        // Materials
        self.materialsTableView.delegate = self
        self.materialsTableView.dataSource = self
        self.materialsTableView.register(AdditionalMaterialsCell.self, forCellReuseIdentifier: "AdditionalMaterialsCell")
        
        self.setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        self.addMedia(nil)
        
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                // Handle error
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Kogyo"
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            configuration.allowsDelayedPaymentMethods = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        })
        task.resume()
        
        self.setPayBtnEnabled(to: true)
    }
    
    // MARK: - UI Setup
    private func setupNavbar() {
        // Configure the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Create a New Task"

        // Set the "Pay" button to the right of the navigation bar
        self.navigationItem.rightBarButtonItem = self.payButton
    }
    
    private func setupUI() {
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
        
        self.view.addSubview(materialsTableView)
        materialsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator4 = UIView()
        cf.createSeparatorView(for: self, with: separator4, under: materialsTableView)
        
        self.view.addSubview(jobPaymentView)
        jobPaymentView.translatesAutoresizingMaskIntoConstraints = false
        jobPaymentView.delegate = self
        
        NSLayoutConstraint.activate([
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
            addEquipmentFormView.heightAnchor.constraint(equalToConstant: 25),
            
            materialsTableView.topAnchor.constraint(equalTo: addEquipmentFormView.bottomAnchor, constant: 5),
            materialsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            materialsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            materialsTableView.heightAnchor.constraint(equalToConstant: 100),
            
            // Changing it manually.
            separator4.topAnchor.constraint(equalTo: materialsTableView.bottomAnchor, constant: 10),
            
            jobPaymentView.topAnchor.constraint(equalTo: separator4.bottomAnchor, constant: 15),
            jobPaymentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobPaymentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobPaymentView.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func setPayBtnEnabled(to isEnabled: Bool) {
        if isEnabled {
            self.payButton.isEnabled = true
            self.payButton.tintColor = .systemBlue
        } else {
            self.payButton.isEnabled = false
            self.payButton.tintColor = .systemGray
        }
    }
    
    // MARK: - Selectors & Functions
    // Function that gets called when the "Pay" button is tapped
    @objc private func didTapPay() {
        let dateAdded = Date()
        let kind = self.jobKindView.pickerTextField.text ?? ""
        let description = self.descriptionFormView.descriptionTextView.text ?? ""
        let dateTime = self.jobDateTimeView.datePicker.date
        let expHours = Int(self.jobHoursView.pickerTextField.text ?? "") ?? 0
        let location = self.jobDateTimeView.addressLabel.text ?? "Click to set location"
        let payment = Int(self.jobPaymentView.paymentTextField.text ?? "") ?? 0
        
        if kind == "" || description == "" || expHours == 0 || location == "" || payment == 0 || location == "Click to set location" {
            AlertManager.showMissingJobInfoAlert(on: self)
        } else {
            self.setPayBtnEnabled(to: false)
            
            print("button has been clicked, repeat")
            let taskData: [String : Any] = [
                "userUID": DataManager.shared.currentUser!.userUID,
                "dateAdded": dateAdded,
                "kind": kind,
                "description": description,
                "dateTime": dateTime,
                "expectedHours": expHours,
                "location": location,
                "payment": payment,
                "completionStatus": "notComplete",
            ]
            
            if let safePaymentSheet = paymentSheet {
                safePaymentSheet.present(from: self) { paymentResult in // Handle payment result
                    switch paymentResult {
                    case .completed:
                        print("Your order is confirmed")
                        Task {
                            do { // Upload task to database.
                                let taskUID = try await FirestoreHandler.shared.uploadTask(taskData: taskData, mediaData: self.mediaData)
                                let userUID = DataManager.shared.currentUser!.userUID
                                self.presentLoadingScreen(jobUID: taskUID, userId: userUID)
                            } catch {
                                print("Error adding job: \(error.localizedDescription)")
                            }
                        }
                    case .canceled:
                        print("Canceled!")
                        self.setPayBtnEnabled(to: true)
                        
                    case .failed(let error):
                        print("Payment failed: \(error)")
                        self.setPayBtnEnabled(to: true)
                    }
                }
            } else {
                print("The surver isn't running you dummy! I need it to be able to create payment request.")
                self.setPayBtnEnabled(to: true)
            }
        }
    }
    
    private func presentLoadingScreen(jobUID: String, userId: String) {
        let loadingScreenController = CustomerLoadingScreenController(jobId: jobUID, userId: userId)
        self.navigationController?.pushViewController(loadingScreenController, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
}

extension CustomerCreateTaskController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalMaterialsCell", for: indexPath) as! AdditionalMaterialsCell
        let materialData = materials[indexPath.row]
        cell.configure(with: materialData)
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            materials.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension CustomerCreateTaskController: EquipmentViewDelegate {
    func didTapAdditionalMaterialsBtn() {
        let viewController = AdditionalMaterialsController()
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
}

extension CustomerCreateTaskController: AdditionalMaterialsDelegate {
    func didEnterMaterial(_ data: (String, Int, Float)) {
        let (name, quantity, price) = data
        
        // Check if the material already exists in the list
        if let index = materials.firstIndex(where: { $0.0 == name && $0.2 == price }) {
            // Update the existing material's quantity
            var existingMaterial = materials[index]
            existingMaterial.1 += quantity
            materials[index] = existingMaterial
        } else {
            materials.append(data)
        }
        
        self.materialsTableView.reloadData()
        self.navigationController?.dismiss(animated: true)
    }
}

extension CustomerCreateTaskController: JobPaymentViewDelegate {
    func paymentTextFieldPressed() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let seconds = 0.05
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            UIView.transition(
                with: self.view, duration: 0.2,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = -self.keyboardHeight + 50
                })
        }
    }
    
    func paymentTextFieldDismissed() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.1,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = 0
                })
        }
    }
}


extension CustomerCreateTaskController: JobDateTimeViewDelegate {
    func pressedLocationButton() {
        let addressPickerController = MapController()
        addressPickerController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(addressPickerController, animated: true)
    }
}

// MARK: - Media View Functions and Delegate
extension CustomerCreateTaskController: MediaViewDelegate {
    
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

extension CustomerCreateTaskController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
