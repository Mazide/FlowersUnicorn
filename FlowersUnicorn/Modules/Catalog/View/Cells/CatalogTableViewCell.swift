//
//  CatalogTableViewCell.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import AlamofireImage

struct CatalogItemCollectionCellModel: CellModel {    
    var modelId: String
    var cellId: String
    var tapHandler: CellModelTapHandler?
    var buyHandler: CellModelTapHandler?
    var isInBasketHandler: ((CellModel) -> Bool)?
    var size: CGSize
    
    var imagePath: String
    var price: String
    var title: String
}

class CatalogTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: CatalogItemButton!
    @IBOutlet weak var gradientView: UIView!
    
    private var catalogCellModel: CatalogItemCollectionCellModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
    }
    
    @IBAction func buy() {
        catalogCellModel?.buyHandler?(catalogCellModel)
        
        checkIsInBasket()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemImageView.layer.cornerRadius = 15
        itemImageView.clipsToBounds = true
        
        let path = UIBezierPath(roundedRect: gradientView.bounds,
                                byRoundingCorners: [.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 15, height: 15))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        gradientView.layer.mask = maskLayer
        gradientView.clipsToBounds = true
    }
    
    func checkIsInBasket() {
        let isInBasket = catalogCellModel?.isInBasketHandler?(catalogCellModel) ?? false
        let buyButtonTitle = isInBasket ? "В Корзине" : catalogCellModel.price
        buyButton.setTitle(buyButtonTitle, for: .normal)
    }
}

extension CatalogTableViewCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let catalogCellModel = cellModel as? CatalogItemCollectionCellModel else {
            fatalError("Incorrect cell model type for CatalogItemCell")
        }
                
        self.catalogCellModel = catalogCellModel
        
        buyButton.titleLabel?.text = catalogCellModel.price
                
        if let imageURL = URL(string: catalogCellModel.imagePath) {
            itemImageView?.clipsToBounds = true
            itemImageView?.af_setImage(withURL: imageURL, completion: { [weak self] (response) in
                self?.setNeedsLayout()
            })
        }
        
        titleLabel.text = catalogCellModel.title
        
        checkIsInBasket()
    }
}


internal extension CatalogTableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        let animationOptions: UIView.AnimationOptions = true
        ? [.allowUserInteraction] : []
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }

}
