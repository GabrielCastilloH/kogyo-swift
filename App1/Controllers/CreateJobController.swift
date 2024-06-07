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
        
        self.view.addSubview(jobKindView)
        jobKindView.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        createSeparatorView(with: separator1, under: jobKindView)
        
        self.view.addSubview(descriptionFormView)
        descriptionFormView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            jobKindView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            jobKindView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            jobKindView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            jobKindView.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionFormView.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 15),
            descriptionFormView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            descriptionFormView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            descriptionFormView.heightAnchor.constraint(equalToConstant: 80),
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
