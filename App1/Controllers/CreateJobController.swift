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
    
    // MARK: - UI Components
    
    
    // MARK: - Life Cycle
    init(kind: String) {
        self.jobKind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]

        self.navigationItem.title = "Create a New Job"
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let jobKindView = JobKindView(kind: jobKind)
        let descriptionFormView = DescriptionFormView()
        let mediaFormView = MediaFormView()
        let jobDateTimeView = JobDateTimeView()
        let jobHoursView = JobHoursView()
        let addEquipmentFormView = AddEquipmentFormView()
        
        self.view.addSubview(jobKindView)
        jobKindView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        createSeparatorView(with: separator1, under: jobKindView)
        
        self.view.addSubview(descriptionFormView)
        descriptionFormView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mediaFormView)
        mediaFormView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2 = UIView()
        createSeparatorView(with: separator2, under: mediaFormView)
        
        self.view.addSubview(jobDateTimeView)
        jobDateTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator3 = UIView()
        createSeparatorView(with: separator3, under: jobDateTimeView)
        
        self.view.addSubview(jobHoursView)
        jobHoursView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addEquipmentFormView)
        addEquipmentFormView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
            addEquipmentFormView.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    
    private func createSeparatorView(with separator: UIView, under view: UIView) {
        separator.backgroundColor = Constants().lightGrayColor.withAlphaComponent(0.3)
        
        self.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    // MARK: - Selectors
}
