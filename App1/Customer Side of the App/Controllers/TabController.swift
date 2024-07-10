//
//  TabController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/4/24.
//

import UIKit

class TabController: UITabBarController {
    
    let isWorker: Bool
    
    init(isWorker: Bool) {
        self.isWorker = isWorker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = Constants().darkWhiteColor
        self.tabBar.tintColor = Constants().darkGrayColor
        self.tabBar.unselectedItemTintColor = Constants().darkGrayColor.withAlphaComponent(0.5)
        
        isWorker ? setupHelperTabs() : setupCustomerTabs()
    }
    
    // MARK: - Setup Tabs
    // setupTabs and createNav is just to simplify process.
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
    
    private func setupCustomerTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeController())
        let allTasks = self.createNav(with: "Tasks", and: UIImage(systemName: "clock"), vc: CurrentTasksController())
        let settings = self.createNav(with: "Settings", and: UIImage(systemName: "gearshape"), vc: SettingsController())
        
        self.setViewControllers([home, allTasks, settings], animated: true)
    }
    
    private func setupHelperTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HelperHomeController())
        let allJobs = self.createNav(with: "Tasks", and: UIImage(systemName: "clock"), vc: CurrentTasksController())
        let settings = self.createNav(with: "Settings", and: UIImage(systemName: "gearshape"), vc: SettingsController())
        
        self.setViewControllers([home, allJobs, settings], animated: true)
    }
}
    
