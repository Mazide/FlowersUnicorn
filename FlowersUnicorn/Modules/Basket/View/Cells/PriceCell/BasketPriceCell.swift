//
//  BasketPriceCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 05.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketPriceCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
}

extension BasketPriceCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let priceCellModel = cellModel as? BasketPriceCellModel else {
            fatalError("Incorect cell model type")
        }
        
        priceCellModel.priceDidChange = { [weak priceLabel] price in
            priceLabel?.text = "Сумма: " + price
        }

    }
}
