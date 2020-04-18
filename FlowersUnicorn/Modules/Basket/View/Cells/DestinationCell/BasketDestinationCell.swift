//
//  BasketDestinationCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 05.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketDestinationCellModel: CellModel {
    var modelId: String = "BasketDestinationCellModel"
    
    var cellId: String = "BasketDestinationCell"
    
    var tapHandler: CellModelTapHandler?
    
    var size: CGSize = CGSize(width: 100, height: 70)
    
    let title: String

    let price: String
    
    var selected: Bool
    
    var stateChangedHandler: ((Bool) -> Void)?
    
    var deliverySpot: DeliverSpot?
   
    init(title: String, price:String, selected: Bool) {
        self.title = title
        self.selected = selected
        self.price = price
    }
}

class BasketDestinationCell: UITableViewCell {
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var containerDestinationView: UIView!
    @IBOutlet weak var priceLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        self.containerDestinationView.layer.cornerRadius = 12
        self.containerDestinationView.layer.masksToBounds = true
    }
}

extension BasketDestinationCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let destinationCellModel = cellModel as? BasketDestinationCellModel else {
            fatalError("incorrect type BasketDestinationCellModel")
        }
        
        destinationLabel.text = destinationCellModel.title
        destinationLabel.backgroundColor = .clear
        priceLabel.text = destinationCellModel.price + " ₽"

        setup(selected: destinationCellModel.selected)
        destinationCellModel.stateChangedHandler = { [weak self] selected in
            self?.setup(selected: selected)
        }
    }
    
    func setup(selected: Bool) {
        containerDestinationView.backgroundColor = selected ? UIColor.indigoBlue : UIColor.white
        destinationLabel.textColor = selected ? UIColor.white : UIColor.greyishBrown
        containerDestinationView.layer.borderWidth = 0.5
        containerDestinationView.layer.borderColor = selected ? UIColor.indigoBlue.cgColor : UIColor.veryLightPink.cgColor
        priceLabel.textColor = selected ? UIColor.white : UIColor.greyishBrown
    }
}
