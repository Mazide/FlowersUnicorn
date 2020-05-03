//
//  BasketButton.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 12.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketButton: UIButton {
    
    var infoLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let label = WhiteLabel()
        label.text = "Корзина"
        label.font = UIFont.init(name: "RobotoSlab-Regular", size: 18)

        addSubview(label)
        
        infoLabel = WhiteLabel()
        infoLabel.text = "3900 Р"
        infoLabel.font = UIFont.init(name: "RobotoSlab-SemiBold", size: 18)
        addSubview(infoLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.height/2
        
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0

        
    }
}
