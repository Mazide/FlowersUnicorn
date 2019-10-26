//
//  MainViewController.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 26.10.2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogModuleFactory = CatalogModuleFactory()
        let module = catalogModuleFactory.createModule()
        if let viewController = module.view as? UIViewController {
            viewControllers = [viewController]
        }
    }
}
