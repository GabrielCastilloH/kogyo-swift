//
//  TaskRequiredEquipmentView.swift
//  App1
//
//  Created by Gabriel Castillo on 7/12/24.
//

import UIKit

class TaskRequiredEquipmentView: UIView {

    // MARK: - Variables
    let cf = CustomFunctions()
    let requiredEquipment: [String]
    
    
    // MARK: - UI Components
    let equipmentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .clear // UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
//        textView.leftSpace()
        return textView
    }()
    
    // MARK: - Life Cycle
    init(for task: TaskClass) {
        self.requiredEquipment = task.equipment
        
        super.init(frame: .zero)
        self.setupUI()
        self.setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let requiredEquipmentTitle = cf.createFormLabel(for: "Expected Required Equipment")
        
        self.addSubview(requiredEquipmentTitle)
        requiredEquipmentTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(equipmentTextView)
        equipmentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            requiredEquipmentTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            requiredEquipmentTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            equipmentTextView.topAnchor.constraint(equalTo: requiredEquipmentTitle.bottomAnchor, constant: 0),
            equipmentTextView.leadingAnchor.constraint(equalTo: requiredEquipmentTitle.leadingAnchor),
            equipmentTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            equipmentTextView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupTextField() {
        var equipmentText = ""
        for equipment in requiredEquipment {
            equipmentText += "\(equipment)\n"
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .regular)
        ]
        if equipmentText != "" {
            
            
            self.equipmentTextView.attributedText = NSAttributedString(string: equipmentText, attributes: attributes)
            
        } else {
            self.equipmentTextView.attributedText = NSAttributedString(string: "No expected required equipment.",
                                                                       attributes: attributes)
        }
    }

    // MARK: - Selectors

}
