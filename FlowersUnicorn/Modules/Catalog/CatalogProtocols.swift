//
//  CatalogViewControllers.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 26.10.2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import Foundation

protocol CatalogModuleOutput {
    func didSelectCatalogItem(with id: String, closeHandler: @escaping () -> Void) 
    func didTapBasket(basketCloseHandler: @escaping () -> Void)
}

protocol CatalogViewInput: ListViewInput {
    func showBasketButton(show: Bool)
    func setupPrice(priceString: NSAttributedString)
}

protocol CatalogViewOutput {
    func loadData()
    func didTapBasket()
}
