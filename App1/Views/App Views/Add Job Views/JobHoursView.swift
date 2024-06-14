//
//  JobHoursView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

class JobHoursView: UIView {
    // MARK: - Variables
    let cf = CustomFunctions()
    var possibleHours: [String] = {
        var list = ["0"]
        for i in 1...15 {
            list.append(String(i))
        }
        return list
    }()
    
    
    // MARK: - UI Components
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        return picker
    }()
    
    public let pickerTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants().darkWhiteColor
        textField.attributedPlaceholder = CustomFunctions()
            .createPlaceholder(for: "?")
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.textAlignment = .center
        return textField
    }()
    
    private let pickerToolbar: UIToolbar = {
            let toolbar = UIToolbar()
            toolbar.barStyle = UIBarStyle.default
            toolbar.tintColor = .systemBlue
            return toolbar
        }()
    
    private lazy var pickerToolbarDone = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(pickerToolbarDonePressed)
    )
    
    private lazy var flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
    
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "hours"
        return label
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerTextField.inputView = pickerView
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let hoursTitle = cf.createFormLabel(for: "Expected Hours:")
        
        self.addSubview(hoursTitle)
        hoursTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(pickerTextField)
        pickerTextField.translatesAutoresizingMaskIntoConstraints = false
        pickerTextField.inputAccessoryView = pickerToolbar
        pickerToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        self.pickerToolbar.setItems([flexButton, flexButton, flexButton, pickerToolbarDone], animated: true)

        
        self.addSubview(hoursLabel)
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            hoursTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            hoursTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            pickerTextField.leadingAnchor.constraint(equalTo: hoursTitle.trailingAnchor, constant: 10),
            pickerTextField.widthAnchor.constraint(equalToConstant: 50),
            
            hoursLabel.bottomAnchor.constraint(equalTo: hoursTitle.bottomAnchor),
            hoursLabel.leadingAnchor.constraint(equalTo: pickerTextField.trailingAnchor, constant: 5),
            
        ])
    }

    // MARK: - Selectors
    @objc func pickerToolbarDonePressed() {
        pickerTextField.resignFirstResponder()
    }
}

// MARK: - Picker View
extension JobHoursView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.possibleHours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.possibleHours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = self.possibleHours[row]
    }
}
