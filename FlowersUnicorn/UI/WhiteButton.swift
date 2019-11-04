//
//  WhiteButton.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class WhiteButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
    }
}
