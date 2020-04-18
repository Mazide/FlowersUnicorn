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
    
    private func createBasketViewController() -> UIViewController {
        let basketViewController = BasketView(nibName: "BasketView", bundle: nil)
        let basketPresenter = BasketViewPresenter(view: basketViewController, moduleOutput: self)
        basketViewController.output = basketPresenter
        let navigationController = UINavigationController(rootViewController: basketViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}

extension CatalogCoordinator: CatalogModuleOutput {
    func didTapBasket() {
        let basketViewController = createBasketViewController()
        catalogViewController?.present(basketViewController, animated: true, completion: nil)
    }
    
    func didSelectCatalogItem(with id: String) {
        let view = CatalogItemDetailView.init(nibName: "CatalogItemDetailView", bundle: nil)
        let presenter = CatalogItemDetailPresenter(view: view, moduleOutput: self, itemId: id)
        view.output = presenter
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
