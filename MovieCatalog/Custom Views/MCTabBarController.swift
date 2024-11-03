//
//  MCTabBarController.swift
//  MovieCatalog
//
//  Created by dark type on 13.10.2024.
//

import UIKit

class MCTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }

    private func setupCustomTabBar() {
        let customTabBar = MCTabBar()
        
        setValue(customTabBar, forKey: "tabBar")
    }
}
