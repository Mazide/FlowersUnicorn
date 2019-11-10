//
//  CatalogPresenter.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

final class CatalogPresenter: NSObject {
    weak var view: CatalogViewInput!
    
    let catalogService = CatalogService()
    let moduleOutput: CatalogModuleOutput
    
    init(view: CatalogViewInput, moduleOutput: CatalogModuleOutput) {
        self.view = view
        self.moduleOutput = moduleOutput
    }
}

extension CatalogPresenter: CatalogViewOutput {
    func loadData() {
        checkBasket(animated: false)
        
        let cellID = "CatalogTableViewCell"
        
        catalogService.obtainCatalogItems { [weak self] catalogItems in
            let cellModels = catalogItems.map { (catalogItem) -> CatalogItemCollectionCellModel in
                let tapHandler: (CellModel) -> Void = { cellModel in
                    self?.moduleOutput.didSelectCatalogItem(with: cellModel.modelId)
                }
                
                let buyHandler: (CellModel) -> Void = { cellModel in
                    let isInBusket = BasketService.shared.isContain(id: cellModel.modelId)
                    if isInBusket {
                        BasketService.shared.remove(id: cellModel.modelId)
                    } else {
                        BasketService.shared.add(id: cellModel.modelId)
                    }
                    
                    self?.checkBasket(animated: true)
                }
                
                let isItemInBusket: (CellModel) -> Bool = { cellModel in
                    return BasketService.shared.isContain(id: cellModel.modelId)
                }
                
                let cellModel = CatalogItemCollectionCellModel.init(modelId: catalogItem.id,
                                                                    cellId: cellID,
                                                                    tapHandler: tapHandler,
                                                                    buyHandler: buyHandler,
                                                                    isInBasketHandler: isItemInBusket,
                                                                    size: CGSize(width: 200, height: 500),
                                                                    imagePath: catalogItem.imagePath,
                                                                    price: String(catalogItem.price),
                                                                    title: catalogItem.title)
                return cellModel
            }
            
            self?.view.setup(cellModels: cellModels)
        }
    }
    
    func didTapBasket() {
        moduleOutput.didTapBasket()
    }
    
    func checkBasket(animated: Bool) {
        let isBasketEmpty = BasketService.shared.addedIds().count == 0
        view.displayBasket(display: !isBasketEmpty, animated: animated)
    }
}

