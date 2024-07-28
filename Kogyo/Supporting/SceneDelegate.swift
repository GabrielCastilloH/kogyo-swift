//
//  SceneDelegate.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Variables & Default Functions
    var window: UIWindow?
    let isWorker = true // TODO: Change this crap.
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Setup window, clear DataManager, check authentication.
        self.setupWindow(with: scene)
        DataManager.shared.currentJobs = [:]
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        // SceneDelgate setup window.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        windowScene.windows.first?.backgroundColor = .white
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - Auth & Animation Functions
    public func checkAuthentication() {
        // Check if the user is logged in, removes all views from hierarchy.
        self.window?.rootViewController = nil
        self.window?.subviews.forEach { $0.removeFromSuperview() }
        
        // If not logged in present LoginController, otherwise go to present home controller.
        if Auth.auth().currentUser == nil {
            self.animateTransition(to: LoginController(), isWorker: self.isWorker)
        } else {
            self.presentHomeController()
        }
    }
    
    private func presentHomeController() {
        // Presents a loading screen until all data is downloaded.
        let loadingViewController = LogoLoadingController()
        self.window?.rootViewController = loadingViewController
        self.window?.makeKeyAndVisible()
        
        Task {
            await DataManager.shared.fetchDatabaseData(asWorker: self.isWorker)
            self.animateTransition(to: nil, isWorker: self.isWorker)
        }
    }
    
    private func animateTransition(to viewController: UIViewController?, isWorker: Bool) {
        // If viewController is nil then the TabController is presented.
        DispatchQueue.main.async { [weak self] in // Change opacity animation of 0.25 seconds.
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                
                if let vc = viewController {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = nav
                    
                } else {
                    self?.window?.rootViewController = TabController(isWorker: isWorker)
                }
                
                UIView.animate(withDuration: 0.25) {
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}

