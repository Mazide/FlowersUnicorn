//
//  CatalogItemDetailProtocols.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import Foundation

struct CatalogItemDetailViewModel {
    let imagePath: String
    let fullDescription: String
    let isInBasket: () -> Bool
}



protocol CatalogItemDetailViewInput: class {
    func setup(viewModel: CatalogItemDetailViewModel)
}

protocol CatalogItemDetailViewOutput {
    func didTapBuyButton()
    func viewDidLoad()
}

protocol CatalogItemDetailModuleOutput: class {
    
}
