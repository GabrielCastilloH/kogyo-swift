//
//  CreateJobController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/6/24.
//

import UIKit

class CreateJobController: UIViewController {

    
    // MARK: - Variables
    var jobKind: String
    var keyboardHeight: CGFloat = 300
    var cf = CustomFunctions()
    
    // MARK: - UI Components
    private lazy var submitJobBtn: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Submit Job", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.backgroundColor = Constants().lightBlueColor
        button.addTarget(self, action: #selector(didTapSubmitJob), for: .touchUpInside)
        return button
    }()
    
    private let navbarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    // MARK: - Life Cycle
    init(kind: String) {
        self.jobKind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
//        UIApplication.shared.windows.first?.backgroundColor = UIColor.white
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "Create a New Job"
        self.setupUI()
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(navbarBackgroundView)
        navbarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let jobKindView = JobKindFormView(kind: jobKind)
        let descriptionFormView = DescriptionFormView()
        let mediaFormView = MediaFormView()
        let jobDateTimeView = JobDateTimeView()
        let jobHoursView = JobHoursView()
        let addEquipmentFormView = AddEquipmentFormView()
        let jobPaymentView = JobPaymentView()
        
        self.view.addSubview(jobKindView)
        jobKindView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        cf.createSeparatorView(for: self, with: separator1, under: jobKindView)
        
        self.view.addSubview(descriptionFormView)
        descriptionFormView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaFormView)
        mediaFormView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2 = UIView()
        cf.createSeparatorView(for: self, with: separator2, under: mediaFormView)
        
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
        
        let paymentTitle = cf.createFormLabel(for: "Payment:")
        self.view.addSubview(paymentTitle)
        paymentTitle.translatesAutoresizingMaskIntoConstraints = false
        
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
            descriptionFormView.heightAnchor.constraint(equalToConstant: 130),
            
            mediaFormView.topAnchor.constraint(equalTo: descriptionFormView.bottomAnchor, constant: 15),
            mediaFormView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mediaFormView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mediaFormView.heightAnchor.constraint(equalToConstant: 20),
            
            jobDateTimeView.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 15),
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
            jobPaymentView.heightAnchor.constraint(equalToConstant: 45),
            
            paymentTitle.topAnchor.constraint(equalTo: separator5.bottomAnchor, constant: 0),
            paymentTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            paymentTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            paymentTitle.heightAnchor.constraint(equalToConstant: 50),
            
            submitJobBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -110),
            submitJobBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            submitJobBtn.heightAnchor.constraint(equalToConstant: 50),
            submitJobBtn.widthAnchor.constraint(equalToConstant: 180),
        ])
        
        view.bringSubviewToFront(navbarBackgroundView)
        navbarBackgroundView.isHidden = true
    }
    
    // MARK: - Selectors & Functions
    private func presentLoadingScreen() {
        let loadingScreenController = LoadingScreenController()
        self.navigationController?.pushViewController(loadingScreenController, animated: true)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.keyboardHeight = keyboardRectangle.height
            }
    }
    
    @objc func didTapSubmitJob() {
        self.presentLoadingScreen()
    }
}

extension CreateJobController: JobPaymentViewDelegate {
    func paymentTextFieldPressed() {
        
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
        DispatchQueue.main.async {
            UIView.transition(
                with: self.view, duration: 0.1,
                options: .curveLinear,
                animations: {
                    self.view.frame.origin.y = 0
                    self.navbarBackgroundView.isHidden = true
                    // This shit is bugged my bro.
//                    self.navigationController?.setNavigationBarHidden(false, animated: false)
            })
        }
    }
}
