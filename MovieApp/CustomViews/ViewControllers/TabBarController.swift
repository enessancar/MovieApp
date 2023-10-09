//
//  TabBarController.swift
//  MovieApp
//
//  Created by Enes Sancar on 3.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureNavigationBar()
        configureView()
    }
    
    private func configureView() {
        viewControllers = [
            createNavController(for: MoviesVC(), title: "Movies", imageName: "film"),
            createNavController(for: ShowsVC(), title: "Shows", imageName: "tv"),
            createNavController(for: SearchVC(), title: "Search", imageName: "magnifyingglass"),
            createNavController(for: WatchlistVC(), title: "Watchlist", imageName: "list.and.film")
        ]
    }
    
    fileprivate func createNavController(for viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemBackground
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
    
    private func configureTabBar() {
        UITabBar.appearance().tintColor = .systemRed
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemRed
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
