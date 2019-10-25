//
//  AppDelegate.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 09.10.2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewController = MainViewController()
        let navigationVC = UINavigationController.init(rootViewController: viewController)

        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
        return true
    }
}

