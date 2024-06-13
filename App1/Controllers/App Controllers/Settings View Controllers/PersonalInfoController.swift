//
//  PersonalInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class PersonalInfoController: UIViewController {

    
    // MARK: - Variables
    var cf = CustomFunctions()
    let firstLastNameForm = FirstLastNameForm()
    
    // MARK: - UI Components
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
        
        firstLastNameForm.firstNameTextField.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Personal Information"
    }
    
    
    private func setupUI() {
        self.view.addSubview(firstLastNameForm)
        firstLastNameForm.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstLastNameForm.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            firstLastNameForm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            firstLastNameForm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            firstLastNameForm.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    // MARK: - Selectors & Functions
}

extension PersonalInfoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstLastNameForm.firstNameTextField {
            print("first name changed")
        } else {
            print("last name changed.")
        }
        textField.resignFirstResponder()
        
        return true
    }
}
