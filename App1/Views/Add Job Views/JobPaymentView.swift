//
//  JobPaymentView.swift
//  App1
//
//  Created by Gabriel Castillo on 6/8/24.
//

import UIKit

protocol JobPaymentViewDelegate {
    func paymentTextFieldPressed()
    func paymentTextFieldDismissed()
}

class JobPaymentView: UIView {
    
    // MARK: - Variables
    let cf = CustomFunctions()
    var delegate: JobPaymentViewDelegate?
    
    
    // MARK: - UI Components
    private let paymentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = Constants().darkWhiteColor
        textField.attributedPlaceholder = CustomFunctions()
            .createPlaceholder(for: "?") // Here you should put the recommended payment.
        textField.layer.cornerRadius = 5
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.size.height))
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
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
    
    private let dollarsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "$"
        return label
    }()
    
    private let infoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark.circle")
        iv.tintColor = Constants().darkGrayColor
        return iv
    }()
    
    private let recPaymentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "$35" // Recommended payment goes here.
        return label
    }()
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        self.paymentTextField.delegate = self
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        let paymentTitle = cf.createFormLabel(for: "Payment:")
        let recPaymentTitle = cf.createFormLabel(for: "Recommended Payment:")

        self.addSubview(paymentTitle)
        paymentTitle.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(recPaymentTitle)
        recPaymentTitle.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(paymentTextField)
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentTextField.inputAccessoryView = pickerToolbar
        pickerToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        self.pickerToolbar.setItems([flexButton, pickerToolbarDone], animated: true)
        
        self.addSubview(dollarsLabel)
        dollarsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(infoImageView)
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(recPaymentLabel)
        recPaymentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            paymentTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            paymentTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            dollarsLabel.leadingAnchor.constraint(equalTo: paymentTitle.trailingAnchor, constant: 10),
            dollarsLabel.widthAnchor.constraint(equalToConstant: 15),
            
            paymentTextField.bottomAnchor.constraint(equalTo: paymentTitle.bottomAnchor),
            paymentTextField.leadingAnchor.constraint(equalTo: dollarsLabel.trailingAnchor, constant: 5),
            paymentTextField.widthAnchor.constraint(equalToConstant: 100),
            
            infoImageView.centerYAnchor.constraint(equalTo: paymentTextField.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: paymentTextField.trailingAnchor, constant: 10),
            infoImageView.heightAnchor.constraint(equalToConstant: 30),
            infoImageView.widthAnchor.constraint(equalToConstant: 30),
            
            recPaymentTitle.topAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 5),
            recPaymentTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            recPaymentLabel.topAnchor.constraint(equalTo: recPaymentTitle.topAnchor),
            recPaymentLabel.leadingAnchor.constraint(equalTo: recPaymentTitle.trailingAnchor, constant: 10),
        ])
    }

    // MARK: - Selectors
    @objc func pickerToolbarDonePressed() {
        self.delegate?.paymentTextFieldDismissed()
        paymentTextField.resignFirstResponder()
    }
}

extension JobPaymentView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.paymentTextFieldPressed()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
