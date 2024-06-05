//
//  TabController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupTabs()
    }
    
    // MARK: - Setup Tabs
    // setupTabs and createNav is just to simplify process.
    private func setupTabs() {
        
        self.tabBar.backgroundColor = Vars().darkWhiteColor
        self.tabBar.tintColor = Vars().darkGrayColor
        self.tabBar.unselectedItemTintColor = Vars().darkGrayColor.withAlphaComponent(0.5)
        
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeController())
        let allJobs = self.createNav(with: "Jobs", and: UIImage(systemName: "clock"), vc: AllJobsController())
        let profile = self.createNav(with: "Profile", and: UIImage(systemName: "person"), vc: ProfileController())
        
        self.setViewControllers([home, allJobs, profile], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
}
    
