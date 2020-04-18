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
    var catalogItems: [CatalogItem]?
    
    init(view: CatalogViewInput, moduleOutput: CatalogModuleOutput) {
        self.view = view
        self.moduleOutput = moduleOutput
    }
}

extension CatalogPresenter: CatalogViewOutput {
    func loadData() {        
        let cellID = "CatalogTableViewCell"
        
        catalogService.obtainCatalogItems { [weak self] catalogItems in
            self?.catalogItems = catalogItems
            self?.updateBasketButtonState()
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
                    self?.updateBasketButtonState()
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
                                                                    price: String(Int(catalogItem.price)) + " ₽",
                                                                    title: catalogItem.title)
                return cellModel
            }
            
            self?.view.setup(cellModels: cellModels)
        }
    }
    
    func updateBasketButtonState() {
        let show = BasketService.shared.addedIds().count != 0
        guard let items = catalogItems?.filter({ (item) -> Bool in
            return BasketService.shared.isContain(id: item.id)
        }) else {
            return
        }
        
        var totalPrice = 0
        for item in items {
            totalPrice += Int(item.price)
        }
        
        
        
        let totalPriceString = String(items.count) + " " + unicornCountForRussian(count: items.count) + " на " + String(totalPrice) + " ₽"
        let totalPriceStringAttributed = NSAttributedString(string: totalPriceString)
        
        view.showBasketButton(show: show)
        view.setupPrice(priceString: totalPriceStringAttributed)
    }
    

    
    func didTapBasket() {
        moduleOutput.didTapBasket()
    }
}

private extension CatalogPresenter {
    private func unicornCountForRussian(count: Int) -> String{
        
        if (count == 0) {
            return "единорогов"
        }
        
        if (count % 10 == 1
            &&
            count % 100 != 11) {
            
            return "единорог"
        }
        else
            if ((count % 10 >= 2 && count % 10 <= 4)
                &&
                !(count % 100 >= 12 && count % 100 <= 14)) {
                
                return "единорога"
        }
            else
                if (count % 10 == 0
                    ||
                    (count % 10 >= 5 && count % 10 <= 9)
                    ||
                    (count % 100 >= 11 && count % 100 <= 14)) {
                    
                    return "eдинорогов"
        }
        return "Oops!";
    }

}
