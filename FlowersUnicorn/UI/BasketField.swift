//
// Created by Nikita Demidov on 18.04.2020.
// Copyright (c) 2020 Nikita Demidov. All rights reserved.
//

import JVFloatLabeledTextField
import Foundation

class BasketField: JVFloatLabeledTextField {
    var line: CALayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        drawLine()
    }

    func drawLine() {
        guard line == nil else {
            return
        }

        floatingLabelActiveTextColor = UIColor.indigoBlue
        floatingLabelFont = UIFont.init(name: "RobotoSlab-Regular", size: 16)
        floatingLabelYPadding = -10.0
        placeholderColor = UIColor.lightGray

        let line = CALayer()
        let height:CGFloat = 0.5
        line.backgroundColor = UIColor.lightGray.cgColor
        line.frame = CGRect(x: 0,
                            y: (self.frame.size.height - height),
                            width: self.frame.size.width,
                            height: height)
        self.line = line
        layer.addSublayer(line)
    }
}
