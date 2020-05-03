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

class BasketFieldCellModel: CellModel {
    var modelId: String = "BasketFieldCell"
    
    var cellId: String = "BasketFieldCell"
    
    var tapHandler: CellModelTapHandler? = nil
    
    var size: CGSize = CGSize(width: 0, height: 55)

    let placeholder: String

    let text: String?

    let fieldKeyboardType: UIKeyboardType

    let textDidChangeHandler: BasketFieldCellTextDidChangeHandler?

    var setupErrorState: ((Bool) -> Void)?

    init(placeholder: String, text: String?, fieldKeyboardType: UIKeyboardType, textDidChangeHandler: BasketFieldCellTextDidChangeHandler?) {
        self.placeholder = placeholder
        self.text = text
        self.fieldKeyboardType = fieldKeyboardType
        self.textDidChangeHandler = textDidChangeHandler
    }
}

class BasketFieldCell: UITableViewCell {
    @IBOutlet weak var field: BasketField!
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
        field.text = fieldCellModel.text
        fieldCellModel.setupErrorState = { [weak self] enableError in
            self?.field.line?.backgroundColor = UIColor.red.cgColor
            self?.field.placeholderColor = UIColor.red
        }
    }
    
    @IBAction func textDidChange() {
        field.line?.backgroundColor = UIColor.lightGray.cgColor
        field.placeholderColor = UIColor.lightGray
        textDidChangeHandler?(field)
    }
}

extension BasketFieldCell: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}