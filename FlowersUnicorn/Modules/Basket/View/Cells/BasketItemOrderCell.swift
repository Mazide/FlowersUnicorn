//
//  BasketItemOrderCell.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import AlamofireImage

struct BasketItemOrderCellModel: CellModel {
    let modelId: String
    
    let cellId: String
    
    let tapHandler: CellModelTapHandler?
    
    let size: CGSize
    
    let title: String
    
    let count: Int
    
    let iconPath: String
}

class BasketItemOrderCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension BasketItemOrderCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let basketItemCellModel = cellModel as? BasketItemOrderCellModel else {
            fatalError("Incorect cell model type")
        }
        
        titleLabel.text = basketItemCellModel.title
        
        if let url = URL.init(string: basketItemCellModel.iconPath) {
            photoView?.af_setImage(withURL: url)
        }
    }
}
