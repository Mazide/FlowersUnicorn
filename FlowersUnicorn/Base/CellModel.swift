//
//  CellModel.swift
//  StepQuest
//
//  Created by Home on 23/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

typealias CellModelTapHandler = (CellModel) -> Void

protocol CellModel {
    var modelId: String { get }
    var cellId: String { get }
    var tapHandler: CellModelTapHandler? { get }
    var size: CGSize { get }
}

protocol CellModelConfigurable {
    func configure(with cellModel: CellModel)
}

protocol ListViewInput: class {
    func setup(cellModels: [CellModel])
}

protocol ListViewOutput: class {
    func viewDidLoad()
}
