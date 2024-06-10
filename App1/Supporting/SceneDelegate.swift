//
//  SceneDelegate.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//
//
//import UIKit
//import FirebaseAuth
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        setupWindow(with: scene)
//    }
//    
//    private func setupWindow(with scene: UIScene) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        windowScene.windows.first?.backgroundColor = .white
//        let window = UIWindow(windowScene: windowScene)
//        self.window = window
//        self.window?.makeKeyAndVisible()
//        window.rootViewController = TabController()
//    }
//    
//    public func checkAuthentication() {
//            if Auth.auth().currentUser == nil {
//                // Go to sign in screen
//                print("should go to sign in screen.")
//                UIView.animate(withDuration: 0.25) {
//                    self.window?.layer.opacity = 0
//                } completion: { [weak self] _ in
//                    
//                let loginController = LoginController()
//                loginController.modalPresentationStyle = .fullScreen
//                self?.window?.rootViewController?.navigationController?.pushViewController(loginController, animated: true)
//                    
//                    UIView.animate(withDuration: 0.25) {
//                        self?.window?.layer.opacity = 1
//                    }
//                }
//            }
//        }
//}





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
            self.window?.rootViewController = TabController()
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        
    }
        
}

