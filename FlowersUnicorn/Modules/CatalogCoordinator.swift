//
//  CatalogCoordinator.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class CatalogCoordinator {
    
    var catalogViewController: UIViewController?
    
    func startCatalogFlow() -> UIViewController {
        let catalogModuleFactory = CatalogModuleFactory()
        let module = catalogModuleFactory.createModule(with: self)
        guard let viewController = module.view as? UIViewController else {
            fatalError("Catalog module factory created empty or wrong type view")
        }

        catalogViewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.largeContentTitle = "Каталог"
        } else {
            // Fallback on earlier versions
        }
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
}

extension CatalogCoordinator: CatalogModuleOutput {
    func didTapBasket(basketCloseHandler: @escaping () -> Void) {
        let basketViewController = BasketView(nibName: "BasketView", bundle: nil)
        basketViewController.dismissHandler = basketCloseHandler
        let basketPresenter = BasketViewPresenter(view: basketViewController, moduleOutput: self)
        basketViewController.output = basketPresenter
        let navigationController = UINavigationController(rootViewController: basketViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        catalogViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func didSelectCatalogItem(with id: String, closeHandler: @escaping () -> Void) {
        let view = CatalogItemDetailView.init(nibName: "CatalogItemDetailView", bundle: nil)
        let presenter = CatalogItemDetailPresenter(view: view, moduleOutput: self, itemId: id)
        view.output = presenter
        view.dismissHandler = closeHandler
        catalogViewController?.present(view, animated: true, completion: nil)
    }
}

extension CatalogCoordinator: BasketModuleOutput {
    func didSelectItem(with id: String) {
        let view = CatalogItemDetailView.init(nibName: "CatalogItemDetailView", bundle: nil)
        let presenter = CatalogItemDetailPresenter(view: view, moduleOutput: self, itemId: id)
        view.output = presenter
        catalogViewController?.present(view, animated: true, completion: nil)
    }
}

extension CatalogCoordinator: CatalogItemDetailModuleOutput {
    
}
