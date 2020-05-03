//
//  BasketOrderButtonCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BasketOrderButtonCellModel: CellModel {
    var modelId: String = ""
    
    var cellId: String = "BasketOrderButtonCell"
    
    var tapHandler: CellModelTapHandler?
    
    var size: CGSize = CGSize(width: 100, height: 350)
    
    var orderButtonHandler: () -> Void

    var updateLabelsHandler: ((String, String, String, String) -> Void)?
    
    var commentChangeHandler: (String) -> Void
    
    init(orderButtonHandler: @escaping () -> Void, commentChangeHandler: @escaping (String) -> Void) {
        self.orderButtonHandler = orderButtonHandler
        self.commentChangeHandler = commentChangeHandler
    }
}

class BasketOrderButtonCell: UITableViewCell {
    var orderButtonHandler: (() -> Void)?
    var commentChangeHandler: ((String) -> Void)?
    
    @IBOutlet weak var commentTextView: JVFloatLabeledTextView!
    @IBOutlet weak var orderButton: UIButton!

    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!

    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var deliveryPriceTitleLabel: UILabel!
    @IBOutlet weak var fullPriceTitleLabel: UILabel!

    @IBAction func orderButtonTapped() {
        orderButtonHandler?()
    }
}

extension BasketOrderButtonCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let orderButtonCellModel = cellModel as? BasketOrderButtonCellModel else {
            fatalError("incorrect cell model type")
        }
        
        commentTextView.delegate = self
        
        orderButtonCellModel.updateLabelsHandler = { [weak self] price, deliveryPrice, deliveryTitle, fullPrice in
            self?.deliveryPriceLabel.text = deliveryPrice
            self?.priceLabel.text = price
            self?.fullPriceLabel.text = fullPrice
            self?.deliveryPriceTitleLabel.text = deliveryTitle
        }
        commentTextView.backgroundColor = UIColor.paleGrey
        commentTextView.layer.cornerRadius = 14
        commentTextView.layer.borderColor = UIColor.veryLightPink.cgColor
        orderButton.backgroundColor = UIColor.indigoBlue
        orderButton.setTitleColor(UIColor.white, for: .normal)
        orderButton.layer.cornerRadius = 14
        orderButtonHandler = orderButtonCellModel.orderButtonHandler
        commentChangeHandler = orderButtonCellModel.commentChangeHandler
    }
}

extension BasketOrderButtonCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.commentChangeHandler?(textView.text)
    }
}
