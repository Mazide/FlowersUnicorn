//
//  CatalogItemDetailView.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import AlamofireImage
import WebKit

class CatalogItemDetailView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: WKWebView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel: CatalogItemDetailViewModel?
    let basketService = BasketService.shared
    var dismissHandler: (() -> Void)?

    var  output: CatalogItemDetailViewOutput!
    
    var imageViewID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
    
    @IBAction func buy() {
        output.didTapBuyButton()
        updateButtonStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissHandler?()
    }
    
    func updateButtonStatus() {
        guard let viewModel = self.viewModel else {
            return
        }

        let isInBasket = basketService.isContain(id: viewModel.id)
        if isInBasket {
            buyButton.setTitle("В корзине", for: .normal)
            buyButton.setTitleColor(isInBasket ? .white : .pinkRed, for: .normal)
            buyButton.backgroundColor = isInBasket ? .indigoBlue : .white
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let priceStr = String(Int(viewModel.price)) + " ₽"
                self.buyButton.setTitle(priceStr, for: .normal)
            }
        } else {
            let priceStr = String(Int(viewModel.price)) + " ₽"
            buyButton.setTitle(priceStr, for: .normal)
            buyButton.setTitleColor(isInBasket ? .white : .pinkRed, for: .normal)
            buyButton.backgroundColor = isInBasket ? .indigoBlue : .white
        }
    }
}

extension CatalogItemDetailView: CatalogItemDetailViewInput {
    func setup(viewModel: CatalogItemDetailViewModel) {
        if let url = URL.init(string: viewModel.imagePath) {
            imageView.af.setImage(withURL: url)
        }
        
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.loadHTMLString(viewModel.fullDescription, baseURL: nil)
        titleLabel.text = viewModel.title
        self.viewModel = viewModel
        
        let title = viewModel.isInBasket() ? "В корзине" : "Купить"
        buyButton.setTitle(title, for: .normal)
        updateButtonStatus()
    }
}
