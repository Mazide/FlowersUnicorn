//
//  BasketDateCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

typealias BasketDateDidChange = (String) -> Void

class BasketDateCellModel: CellModel {
    var modelId: String = "BasketDateCellModel"
    
    var cellId: String = "BasketDateCell"
    
    var tapHandler: CellModelTapHandler?
    
    var size: CGSize = CGSize(width: 100, height: 55)
    
    var dateChanged: BasketDateDidChange?
}

class BasketDateCell: UITableViewCell {
    @IBOutlet weak var dateTextField: JVFloatLabeledTextField!
}

extension BasketDateCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let dateCellModel = cellModel as? BasketDateCellModel else {
            fatalError("incorrect type BasketDateCellModel")
        }

        dateCellModel.dateChanged = { [weak self] dateString in
            self?.dateTextField.text = dateString
        }
    }
}
