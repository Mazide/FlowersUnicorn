//
//  CatalogItemCollectionCell.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

struct CatalogItemCollectionCellModel: CellModel {
    var id: String
    var modelId: String
    var cellId: String
    var tapHandler: CellModelTapHandler?
    var size: CGSize
    
    var image: UIImage
    var price: String
    var title: String
}


class CatalogItemCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}

extension CatalogItemCollectionCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        self.backgroundColor =  UIColor.red
        guard let catalogCellModel = cellModel as? CatalogItemCollectionCellModel else {
            fatalError("Incorrect cell model type for CatalogItemCell")
        }
        
        imageView.image = catalogCellModel.image
        priceLabel.text = catalogCellModel.price
        titleLabel.text = catalogCellModel.title
    }
}
