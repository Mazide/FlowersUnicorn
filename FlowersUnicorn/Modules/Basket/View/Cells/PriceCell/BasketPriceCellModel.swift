//
//  BasketPriceCellModel.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

typealias BasketPriceDidChange = (String) -> Void

class BasketPriceCellModel: CellModel {
    var modelId: String = "BasketPriceCell"
    
    var cellId: String = "BasketPriceCell"
    
    var tapHandler: CellModelTapHandler?
    
    var size: CGSize = CGSize(width: 320, height: 160)
    
    var priceDidChange: BasketPriceDidChange?
}
