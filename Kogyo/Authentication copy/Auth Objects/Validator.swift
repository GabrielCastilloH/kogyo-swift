//
//  Validator.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import Foundation

class Validator {
    static func isEmailValid(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isNameValid(for username: String) -> Bool {
            let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
            let usernameRegEx = "[A-Za-z]{1,64}"
            let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
            return usernamePred.evaluate(with: username)
        }
        
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,64}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
