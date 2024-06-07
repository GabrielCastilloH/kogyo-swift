//
//  JobKindView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/7/24.
//

import UIKit

class JobKindView: UIView {

    // MARK: - Variables
    var jobKind: String
    let allJobs: [JobButtonView]
    let cf = CustomFunctions()
    
    
    // MARK: - UI Components
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        return picker
    }()
    
    private let pickerTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants().darkWhiteColor
        textField.attributedPlaceholder = CustomFunctions()
            .createPlaceholder(for: "Select job kind...")
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.size.height))
        return textField
    }()
    
    private let pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .systemBlue
        return toolbar
    }()
    
    private let pickerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = Constants().darkGrayColor
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
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
    
    // MARK: - Life Cycle
    init(kind: String) {
        self.jobKind = kind
        self.allJobs = JobListing().allJobs
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
        let kindLabel = cf.createFormLabel(for: "Kind:")
        
        self.addSubview(kindLabel)
        kindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(pickerTextField)
        pickerTextField.translatesAutoresizingMaskIntoConstraints = false
        pickerTextField.inputAccessoryView = pickerToolbar
        pickerToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        self.pickerToolbar.setItems([flexButton, flexButton, flexButton, pickerToolbarDone], animated: true)
        
        self.addSubview(pickerImage)
        pickerImage.translatesAutoresizingMaskIntoConstraints = false
       
        
        NSLayoutConstraint.activate([
            kindLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            kindLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            pickerTextField.centerYAnchor.constraint(equalTo: kindLabel.centerYAnchor),
            pickerTextField.leadingAnchor.constraint(equalTo: kindLabel.trailingAnchor, constant: 10),
            pickerTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            pickerTextField.heightAnchor.constraint(equalToConstant: 35),
            
            pickerImage.centerYAnchor.constraint(equalTo: kindLabel.centerYAnchor),
            pickerImage.trailingAnchor.constraint(equalTo: pickerTextField.trailingAnchor, constant: -15),
            pickerImage.heightAnchor.constraint(equalToConstant: 25),
        ])
    }

    // MARK: - Selectors
    @objc func pickerToolbarDonePressed() {
        pickerTextField.resignFirstResponder()
    }
}

// MARK: - Picker View
extension JobKindView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.allJobs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.allJobs[row].jobLabel.text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = self.allJobs[row].jobLabel.text
    }
    
    
}
