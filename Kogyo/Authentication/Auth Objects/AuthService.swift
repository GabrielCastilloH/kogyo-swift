//
//  AuthService.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    // Used to register, sign in, sign out, and check authentication for the user.
    public static let shared = AuthService()
    
    private init() {}
    
    /// A method to register the user.
    /// - Parameters:
    ///   - userRequest: The user's information (name, email, password)
    ///   - completion: A completion with two values...
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides one.
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?)->Void) {
        let firstName = userRequest.firstName
        let lastName = userRequest.lastName
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    public func sendSignInLink(to email: String, completion: @escaping(Error?)->Void) async {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "TODO")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        do {
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
        }
        catch let error {
            completion(error)
        }
    }
    
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping(Error?)->Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            // Sign in, catch any errors (return error) or return no errors to the completion handler.
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping(Error?)->Void) {
        // Sign out, catch any errors (return error) or return no errors to the completion handler.
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping(Error?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
