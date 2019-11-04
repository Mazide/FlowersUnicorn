//
//  CatalogViewControllers.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 26.10.2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import Foundation

protocol CatalogModuleOutput {
    func didSelectCatalogItem(with id: String)
    func didTapBasket()
}

protocol CatalogViewInput: ListViewInput {
    func displayBasket(display: Bool, animated: Bool)
}

protocol CatalogViewOutput {
    func loadData()
    func didTapBasket()
}
