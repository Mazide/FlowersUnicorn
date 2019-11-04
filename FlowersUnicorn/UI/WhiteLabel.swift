//
//  WhiteLabel.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class WhiteLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        textColor = .white
    }
}
