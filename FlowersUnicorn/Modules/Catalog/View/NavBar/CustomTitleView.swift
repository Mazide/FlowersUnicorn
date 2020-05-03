//
//  CustomTitleView.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 01.05.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class CustomTitleView: UIView {

    var showInfoTapped: (() -> Void)?
    
    @IBAction func showInfo() {
        showInfoTapped?()
    }
}
