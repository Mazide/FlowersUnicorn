//
//  CatalogItemButton.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 12.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class CatalogItemButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.height/2
        backgroundColor = UIColor.white
    }
}
