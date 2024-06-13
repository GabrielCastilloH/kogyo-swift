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
        setupTabs()
    }
    
    // MARK: - Setup Tabs
    // setupTabs and createNav is just to simplify process.
    private func setupTabs() {
        
        self.tabBar.backgroundColor = Constants().darkWhiteColor
        self.tabBar.tintColor = Constants().darkGrayColor
        self.tabBar.unselectedItemTintColor = Constants().darkGrayColor.withAlphaComponent(0.5)
        
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeController())
        let allJobs = self.createNav(with: "Jobs", and: UIImage(systemName: "clock"), vc: CurrentJobsController())
        let settings = self.createNav(with: "Settings", and: UIImage(systemName: "gearshape"), vc: SettingsController())
        
        self.setViewControllers([home, allJobs, settings], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
}
    
