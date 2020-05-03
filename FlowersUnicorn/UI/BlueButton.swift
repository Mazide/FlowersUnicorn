//
//  BlueButton.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 19.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BlueButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.indigoBlue
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.init(name: "RobotoSlab-Regular.ttf", size: 17)
        self.layer.cornerRadius = 14.0
    }
}
