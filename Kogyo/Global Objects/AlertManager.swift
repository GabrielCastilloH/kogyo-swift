//
//  AlertManager.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

class AlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}


// MARK: - Show Validation Errors
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password\n(6-64 characters, at least 1 number, 1 symbol, and 1 capital letter)  ")
    }
    
    public static func showInvalidFirstNameAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Invalid First Name", message: "Please enter a valid name (only letters).")
    }
    
    public static func showInvalidLastNameAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Invalid Last Name", message: "Please enter a valid name (only letters).")
    }
}

// MARK: - Show Registration Errors and Alerts
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Unkown Registration Error", message: nil)
    }

    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
    
    public static func showPasswordsDontMatchAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Password Error", message: "The passwords you entered don't match.")
    }
    
    public static func showVerifyLinkSent(on vc: UIViewController, with email: String) {
        showBasicAlert(on: vc, title: "Email Verification Sent", message: "To confirm your email address tap the link sent to: \n\(email)")
    }
}

// MARK: - Show SignIn Errors
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Unkown Error Signing in", message: nil)
    }

    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

// MARK: - Show LogOut Errors
extension AlertManager {
    public static func showLogOutErrorAlert(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Show Forgot Password Errors
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: "Error Sending Password Reset", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors
extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        showBasicAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnkownErrorFetchingUser(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Unkown Error Fetching User", message: nil)
    }
}

// MARK: - Show Validation Errors
extension AlertManager {
    public static func showMissingJobInfoAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Missing Information", message: "Please fill out all fields.")
    }
    
    public static func showInvalidCancelReason(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Error", message: "Please select a valid reason for cancellation.")
    }
}

// MARK: - Cancel Alerts
extension AlertManager {
    public static func showCanceledTaskAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Task Canceled", message: "Your task was successfully canceled.")
    }
    
    public static func showCancelAlertCustomer(on vc: CustomerMyTasksController, helper: Helper, task: TaskClass) {
        let title = "Task Canceled"
        let message = "\(helper.firstName) \(helper.lastName) has canceled your \(task.kind) task: \(task.description.prefix(40))... If you'd like to find another helper click \"Find Helper\" below or go to your task history."
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let findHelperAction = UIAlertAction(title: "Find Helper", style: .default) { _ in
                vc.findAnotherHelper()
            }
            alertController.addAction(findHelperAction)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}




// MARK: - Show Other Alerts
extension AlertManager {
    public static func showJobAddedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Task Added", message: "Please go to \"Tasks\" to see your current tasks.")
    }
    
    public static func showTaskAcceptedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Task Accepted", message: "Please go to \"My Tasks\" to see your accepted tasks.")
    }
    
    public static func showNameChangedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, title: "Name Changed", message: "Your name was successfully changed!")
    }
}


