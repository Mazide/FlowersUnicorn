//
//  CatalogItemDetailPresenter.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class CatalogItemDetailPresenter {
    weak var view: CatalogItemDetailViewInput!
    weak var moduleOutput: CatalogItemDetailModuleOutput!
    
    private let catalogService = CatalogService()
    private let basketService = BasketService.shared
    private let itemId: String
    
    init(view: CatalogItemDetailViewInput,
         moduleOutput: CatalogItemDetailModuleOutput,
         itemId: String) {
        self.view = view
        self.moduleOutput = moduleOutput
        self.itemId = itemId
    }
}

extension CatalogItemDetailPresenter: CatalogItemDetailViewOutput {
    func viewDidLoad() {
        catalogService.obtainCatalogItems { [weak self] (items) in
            guard let item = items.filter({ $0.id == self?.itemId }).first else {
                fatalError("There isn't item with whis id")
            }
            
            let viewModel = CatalogItemDetailViewModel(imagePath: item.imagePath, fullDescription: item.fullDescription) { () -> Bool in
                guard let itemId = self?.itemId else {
                    fatalError("Detail item id is nil")
                }
                
                return self?.basketService.isContain(id: itemId) ?? false
            }
            
            self?.view.setup(viewModel: viewModel)
        }
    }
    
    func didTapBuyButton() {
        
    }
}
