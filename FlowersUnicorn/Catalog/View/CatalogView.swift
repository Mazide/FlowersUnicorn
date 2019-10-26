//
//  CatalogView.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class CatalogView: UIViewController {

    var output: CatalogViewOutput?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellModels: [CellModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: REMOVE        
        output?.loadData()
    }
}

extension CatalogView: CatalogViewInput {
    func setup(cellModels: [CellModel]) {
        for cellModel in cellModels {
            let nib = UINib.init(nibName: cellModel.cellId, bundle: nil)
            self.collectionView.register(nib, forCellWithReuseIdentifier: cellModel.cellId)
        }
        
        self.cellModels = cellModels
        self.collectionView.reloadData()
    }
}

extension CatalogView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.cellId, for: indexPath)
        if let configurableCell = cell as? CellModelConfigurable {
            configurableCell.configure(with: cellModel)
        }
        return cell
    }
}

extension CatalogView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        
        return cellModel.size
    }
}
