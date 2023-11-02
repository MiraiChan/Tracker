//
//  TabBarController.swift
//  Tracker
//
//  Created by Almira Khafizova on 27.10.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    let trackersViewController = TrackersViewController()
    let statisticsViewController = StatisticsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarView()
        setupTabBarViewController()
  }    
}

// MARK: - Private methods to setup UI

private extension TabBarController {
    
    func setupTabBarView() {
        //tabBar.isTranslucent = false
        tabBar.tintColor = .ypBlue
        tabBar.backgroundColor = .ypWhite
    }
    
    func setupTabBarViewController() {
        view.backgroundColor = .ypWhite
        
        setupTabBarItem(for: trackersViewController, title: "Трекеры", image: "Trackers")
        setupTabBarItem(for: statisticsViewController, title: "Статистика", image: "Statistics")
        
        let viewControllers = [trackersViewController, statisticsViewController]
        selectedIndex = 0
        self.viewControllers = viewControllers.map { controller in
            UINavigationController(rootViewController: controller)
        }
    }
    
    func setupTabBarItem(for viewController: UIViewController, title: String, image: String) {
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: image),
            selectedImage: nil
        )
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectedViewController = viewController
    }
}
