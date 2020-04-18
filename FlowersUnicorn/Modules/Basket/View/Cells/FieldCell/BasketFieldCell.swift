//
//  BasketFieldCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 05.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

typealias BasketFieldCellTextDidChangeHandler = (UITextField) -> Void

struct BasketFieldCellModel: CellModel {
    var modelId: String = "BasketFieldCell"
    
    var cellId: String = "BasketFieldCell"
    
    var tapHandler: CellModelTapHandler? = nil
    
    var size: CGSize = CGSize(width: 0, height: 55)

    let placeholder: String

    let fieldKeyboardType: UIKeyboardType

    let textDidChangeHandler: BasketFieldCellTextDidChangeHandler?
}

class BasketFieldCell: UITableViewCell {
    @IBOutlet weak var field: JVFloatLabeledTextField!
    var textDidChangeHandler: BasketFieldCellTextDidChangeHandler?
}

extension BasketFieldCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {
        guard let fieldCellModel = cellModel as? BasketFieldCellModel else {
            fatalError("incorrect BasketFieldCellModel type")
        }

        field.delegate = self
        textDidChangeHandler = fieldCellModel.textDidChangeHandler
        field.placeholder = fieldCellModel.placeholder
        field.keyboardType = fieldCellModel.fieldKeyboardType
        field.autocapitalizationType = .words
    }
    
    @IBAction func textDidChange() {
        textDidChangeHandler?(field)
    }
}

extension BasketFieldCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}