//
//  BasketView.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var output: BasketViewOutput!
    var cellModels: [CellModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewDidLoad()
    }
}

extension BasketView: BasketViewInput {
    func setup(cellModels: [CellModel]) {
        for cellModel in cellModels {
            let nib = UINib.init(nibName: cellModel.cellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellModel.cellId)
        }
        
        self.cellModels = cellModels
        self.tableView.reloadData()
    }
}

extension BasketView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellId, for: indexPath)
        if let configurableCell = cell as? CellModelConfigurable {
            configurableCell.configure(with: cellModel)
        }
        return cell
    }
}

extension BasketView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        
        return cellModel.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        
        cellModel.tapHandler?(cellModel)
    }
}
