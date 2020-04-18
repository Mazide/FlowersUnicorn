//
// Created by Nikita Demidov on 18.04.2020.
// Copyright (c) 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
