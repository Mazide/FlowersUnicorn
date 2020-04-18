//
//  BasketItemOrderCell.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import AlamofireImage
import GMStepper

typealias BasketItemOrderCellChangeCountHandler = (Int) -> Int

struct BasketItemOrderCellModel: CellModel {
    let modelId: String
    
    let cellId: String
    
    let tapHandler: CellModelTapHandler?
    
    let size: CGSize
    
    let title: String
    
    let iconPath: String

    let price: String
    
    let changeCountHandler: BasketItemOrderCellChangeCountHandler?
}

class BasketItemOrderCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!

    var changeCountHandler: BasketItemOrderCellChangeCountHandler?

    @IBAction func plus() {
        let count = changeCountHandler?(1) ?? 0
        minusButton.setTitleColor(count != 0 ? .black : .lightGray, for: .normal)
        countLabel.text = String(count)
    }

    @IBAction func minus() {
        let count = changeCountHandler?(-1) ?? 0
        minusButton.setTitleColor(count != 0 ? .black : .lightGray, for: .normal)
        countLabel.text = String(count)
    }
}

extension BasketItemOrderCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let basketItemCellModel = cellModel as? BasketItemOrderCellModel else {
            fatalError("Incorect cell model type")
        }
        
        titleLabel.text = basketItemCellModel.title
        
        photoView.layer.cornerRadius = 4
        priceLabel.text = basketItemCellModel.price

        changeCountHandler = basketItemCellModel.changeCountHandler
        countLabel.text = String(changeCountHandler?(0) ?? 0)

        if let url = URL.init(string: basketItemCellModel.iconPath) {
            photoView?.af_setImage(withURL: url)
        }
    }
}
