//
//  CatalogViewControllers.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 26.10.2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import Foundation

protocol CatalogViewInput: ListView { }

protocol CatalogViewOutput {
    func loadData()
}
