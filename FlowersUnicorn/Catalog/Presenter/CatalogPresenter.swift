//
//  CatalogPresenter.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

final class CatalogPresenter: NSObject {
    weak var view: CatalogViewInput!
    
    init(view: CatalogViewInput) {
        self.view = view
    }
}

extension CatalogPresenter: CatalogViewOutput {
    func loadData() {
        var cellModels = [CellModel]()
        let cellID = "CatalogItemCollectionCell"
        let cellModel = CatalogItemCollectionCellModel.init(id: "",
                                                            modelId: "",
                                                            cellId: cellID,
                                                            tapHandler: nil,
                                                            size: CGSize(width: 200, height: 300),
                                                            image: UIImage(named: "test.jpg")!,
                                                            price: "123",
                                                            title: "Единорог")
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)
        cellModels.append(cellModel)

        self.view.setup(cellModels: cellModels)
    }
}

