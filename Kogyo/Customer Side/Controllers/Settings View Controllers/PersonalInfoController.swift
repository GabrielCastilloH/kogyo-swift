//
//  PersonalInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit
import FirebaseAuth

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
        
        let user = DataManager.shared.currentUser!
        
        self.firstLastNameForm.firstNameTextField.text = user.firstName
        self.firstLastNameForm.lastNameTextField.text = user.lastName
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
        let firstName = self.firstLastNameForm.firstNameTextField.text ?? ""
        let lastName = self.firstLastNameForm.lastNameTextField.text ?? ""
        
        if !Validator.isNameValid(for: firstName) {
            AlertManager.showInvalidFirstNameAlert(on: self)
            return true
        }
        
        if !Validator.isNameValid(for: lastName) {
            AlertManager.showInvalidLastNameAlert(on: self)
            return true
        }
        
        // TODO: Find some way to do this in the Auth class.
        guard let userUID = Auth.auth().currentUser?.uid else { return true }
        FirestoreHandler.shared.editNames(userUID: userUID, firstName: firstName, lastName: lastName)
        textField.resignFirstResponder()
        AlertManager.showNameChangedAlert(on: self)
        
        return true
    }
}
