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
            // Go to home screen
            // Remove this duplicate code when you feel like it broski.
            
            // LOADING VIEW:
            let loadingViewController = UIViewController() // Replace with your actual loading view controller
            self.window?.rootViewController = loadingViewController
            loadingViewController.view.backgroundColor = .systemPink
            self.window?.makeKeyAndVisible()
            
            DataManager.shared.fetchDatabaseData {
                DataManager.shared.printValues()
                
                DispatchQueue.main.async { [weak self] in
                    UIView.animate(withDuration: 0.25) {
                        self?.window?.layer.opacity = 0
                    } completion: { [weak self] _ in
                        
                        self?.window?.rootViewController = TabController()
                        
                        UIView.animate(withDuration: 0.25) {
                            self?.window?.layer.opacity = 1
                        }
                    }
                }
            }
        }
//
//            DispatchQueue.main.async { [weak self] in
//                UIView.animate(withDuration: 0.25) {
//                    self?.window?.layer.opacity = 0
//                } completion: { [weak self] _ in
//                    
//                   
////                    }
//                    self?.window?.rootViewController = TabController()
//                    
//                    UIView.animate(withDuration: 0.25) {
//                        self?.window?.layer.opacity = 1
//                    }
//                }
//            }
//        }
    }
    
    private func goToController(with viewController: UIViewController) {
        
    }
        
}

