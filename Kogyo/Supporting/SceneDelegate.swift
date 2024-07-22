//
//  SceneDelegate.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        DataManager.shared.currentJobs = [:]
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        windowScene.windows.first?.backgroundColor = .white
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        self.window?.rootViewController = nil
        self.window?.subviews.forEach { $0.removeFromSuperview() }
        
        if Auth.auth().currentUser == nil {
            // Go to sign in screen
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.25) {
                    self?.window?.layer.opacity = 0
                } completion: { [weak self] _ in
                    
                    let nav = UINavigationController(rootViewController: LoginController())
                    nav.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = nav
                    
                    UIView.animate(withDuration: 0.25) {
                        self?.window?.layer.opacity = 1
                    }
                }
            }
        } else {
            self.presentHomeController()
        }
    }
    
    private func presentHomeController() {
        // LOADING VIEW:
        let loadingViewController = OpenLoadingController() // Replace with your actual loading view controller
        self.window?.rootViewController = loadingViewController
        self.window?.makeKeyAndVisible()
        
        DataManager.shared.fetchDatabaseData {
            // Remove this duplicate code when you feel like it broski.
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.25) {
                    self?.window?.layer.opacity = 0
                } completion: { [weak self] _ in
                    
                    
                    // TODO: add button or login attribute to make them login as workers. 
                    self?.window?.rootViewController = TabController(isWorker: false)
                    
                    UIView.animate(withDuration: 0.25) {
                        self?.window?.layer.opacity = 1
                    }
                }
            }
        }
    }
        
}

