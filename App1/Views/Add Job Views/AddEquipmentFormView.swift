//
//  AddEquipmentFormView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class AddEquipmentFormView: UIView {
    // MARK: - Variables
    let cf = CustomFunctions()
    
    // MARK: - UI Components
    private lazy var addEquipmentBtn: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = Constants().darkGrayColor
        button.backgroundColor = UIColor(white: 1, alpha: 0)
        button.addTarget(self, action: #selector(didTapMediaButton), for: .touchUpInside)
        return button
    }()
    
    private let plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = Constants().darkGrayColor
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let addEquipmentLabel = cf.createFormLabel(for: "Additional Equipment: ")
        
        self.addSubview(addEquipmentLabel)
        addEquipmentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(plusImage)
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addEquipmentBtn)
        addEquipmentBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addEquipmentLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            addEquipmentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            plusImage.centerYAnchor.constraint(equalTo: addEquipmentLabel.centerYAnchor),
            plusImage.leadingAnchor.constraint(equalTo: addEquipmentLabel.trailingAnchor, constant: 10),
            plusImage.heightAnchor.constraint(equalToConstant: 30),
            
            addEquipmentBtn.topAnchor.constraint(equalTo: plusImage.topAnchor),
            addEquipmentBtn.bottomAnchor.constraint(equalTo: plusImage.bottomAnchor),
            addEquipmentBtn.leadingAnchor.constraint(equalTo: plusImage.leadingAnchor),
            addEquipmentBtn.trailingAnchor.constraint(equalTo: plusImage.trailingAnchor),
            
        ])
    }

    // MARK: - Selectors
    @objc func didTapMediaButton() {
        print("good luck setting up the add equipment func.")
    }

}
