//
//  CatalogTableViewCell.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

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

        let isInBasket = catalogCellModel?.isInBasketHandler?(catalogCellModel) ?? false
        if isInBasket {
            buyButton.setTitle("В корзине", for: .normal)
            buyButton.setTitleColor(isInBasket ? .white : .pinkRed, for: .normal)
            buyButton.backgroundColor = isInBasket ? .indigoBlue : .white
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkIsInBasket()
            }
        } else {
            checkIsInBasket()
        }
    }
    
    func checkIsInBasket() {
        let isInBasket = catalogCellModel?.isInBasketHandler?(catalogCellModel) ?? false
        buyButton.setTitle(catalogCellModel.price, for: .normal)
        buyButton.setTitleColor(isInBasket ? .white : .pinkRed, for: .normal)
        buyButton.backgroundColor = isInBasket ? .indigoBlue : .white
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
            imageContainerView.layer.cornerRadius = 15;
            imageContainerView.contentMode = .scaleAspectFill
            imageContainerView.layer.masksToBounds = true
            itemImageView.af.setImage(withURL: imageURL)
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
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.24,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.24,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }

}
