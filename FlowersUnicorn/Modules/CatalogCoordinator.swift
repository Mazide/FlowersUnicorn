//
//  CatalogCoordinator.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class CatalogCoordinator {
    var navigationController: UINavigationController?
    
    func startCatalogFlow() -> UIViewController {
        let catalogModuleFactory = CatalogModuleFactory()
        let module = catalogModuleFactory.createModule(with: self)
        guard let viewController = module.view as? UIViewController else {
            fatalError("Catalog module factory created empty or wrong type view")
        }

        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController!
    }
}

extension CatalogCoordinator: CatalogModuleOutput {
    func didTapBasket() {
        let basketViewController = BasketView.init(nibName: "BasketView", bundle: nil)
        let basketPresenter = BasketViewPresenter.init(view: basketViewController, moduleOutput: self)
        basketViewController.output = basketPresenter
        navigationController?.viewControllers.first!.present(basketViewController, animated: true, completion: nil  )
    }
    
    func didSelectCatalogItem(with id: String) {
        let view = CatalogItemDetailView.init(nibName: "CatalogItemDetailView", bundle: nil)
        let presenter = CatalogItemDetailPresenter(view: view, moduleOutput: self, itemId: id)
        view.output = presenter
        navigationController?.viewControllers.first!.present(view, animated: true, completion: nil)
    }
}

extension CatalogCoordinator: BasketModuleOutput {
    
}

extension CatalogCoordinator: CatalogItemDetailModuleOutput {
    
}
