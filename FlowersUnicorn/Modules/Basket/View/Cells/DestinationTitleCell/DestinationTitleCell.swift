//
//  DestinationTitleCell.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 18.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

struct DestinationTitleCellModel: CellModel {
    var modelId: String = ""

    var cellId: String = "DestinationTitleCell"

    var tapHandler: CellModelTapHandler? = nil

    var size: CGSize = CGSize(width: 0, height: 50)
}

class DestinationTitleCell: UITableViewCell {
}

extension DestinationTitleCell: CellModelConfigurable {
    func configure(with cellModel: CellModel) {

    }
}