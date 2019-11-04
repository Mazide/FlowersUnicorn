//
//  CatalogItemDetailView.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import Kingfisher

class CatalogItemDetailView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    
    var  output: CatalogItemDetailViewOutput!
    
    var imageViewID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
    }
    
    @IBAction func buy() {
        output.didTapBuyButton()
    }
}

extension CatalogItemDetailView: CatalogItemDetailViewInput {
    func setup(viewModel: CatalogItemDetailViewModel) {
        if let url = URL.init(string: viewModel.imagePath) {
            imageView.kf.setImage(with: url)
        }
        
        descriptionTextView.text = viewModel.fullDescription
        
        let title = viewModel.isInBasket() ? "В корзине" : "Купить"
        buyButton.setTitle(title, for: .normal)
    }
}
