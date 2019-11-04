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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var basketButtonBottomConstaint: NSLayoutConstraint!
    
    var cellModels: [CellModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Каталог"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        output?.loadData()
    }
    
    @IBAction func showBasket() {
        output?.didTapBasket()
    }
}

extension CatalogView: CatalogViewInput {
    func setup(cellModels: [CellModel]) {
        for cellModel in cellModels {
            let nib = UINib.init(nibName: cellModel.cellId, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: cellModel.cellId)
        }
        
        self.cellModels = cellModels
        self.tableView.reloadData()
    }
    
    func displayBasket(display: Bool, animated: Bool) {
        let bottomBasketConstraintConstant: CGFloat = display ? 30 : -100
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            self.basketButtonBottomConstaint.constant = bottomBasketConstraintConstant
            self.view.layoutIfNeeded()
        }
    }
}

extension CatalogView: UITableViewDataSource {
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

extension CatalogView: UITableViewDelegate {
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
