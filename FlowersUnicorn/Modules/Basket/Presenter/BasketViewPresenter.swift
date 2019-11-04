//
//  BasketViewPresenter.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketViewPresenter: NSObject {
    weak var view: BasketViewInput?
    weak var moduleOutput: BasketModuleOutput?
    
    private var basketService = BasketService.shared
    private var catalogService = CatalogService()
    
    init(view: BasketViewInput, moduleOutput: BasketModuleOutput) {
        self.view = view
        self.moduleOutput = moduleOutput
    }
}

extension BasketViewPresenter: BasketViewOutput {
    func viewDidLoad() {
        catalogService.obtainCatalogItems { [weak self] (catalogItems) in
            let basketItems = catalogItems.filter { self?.basketService.isContain(id: $0.id) ?? false }
            
            let basketCellModels = basketItems.map { (item) -> BasketItemOrderCellModel in
                let tapHandler: CellModelTapHandler = { cellModel in
                    
                }
                
                return BasketItemOrderCellModel(modelId: item.id,
                                                cellId: "BasketItemOrderCell",
                                                tapHandler: tapHandler,
                                                size: CGSize.init(width: 320, height: 86),
                                                title: item.title,
                                                count: 1,
                                                iconPath: item.imagePath)
            }
            
            self?.view?.setup(cellModels: basketCellModels)
        }
    }
}
