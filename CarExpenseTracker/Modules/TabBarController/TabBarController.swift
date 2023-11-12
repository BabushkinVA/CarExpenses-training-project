//
//  TabBarController.swift
//  CarExpenseTracker
//
//  Created by Vadim on 8.10.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 0
        tabBar.backgroundColor = .systemOrange
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .black
    }
    
}
