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
    private func createFormLabel(for title: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = title
        return label
    }
    
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
        let kindLabel = createFormLabel(for: "Kind:")
        let descriptionLabel = createFormLabel(for: "Description:")
        let imagesLabel = createFormLabel(for: "Images & Videos:")
        let hoursLabel = createFormLabel(for: "Expected Hours:")
        let additionalEquipment = createFormLabel(for: "Additional Equipment:")
        
        
        self.view.addSubview(kindLabel)
        kindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        createSeparatorView(with: separator1, under: kindLabel)
        
        NSLayoutConstraint.activate([
            kindLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 115),
            kindLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            descriptionLabel.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
        ])
        
    }
    
    
    private func createSeparatorView(with separator: UIView, under view: UIView) {
        separator.backgroundColor = Constants().lightGrayColor.withAlphaComponent(0.3)
        
        self.view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    // MARK: - Selectors

}
