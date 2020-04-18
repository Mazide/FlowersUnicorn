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
    @IBOutlet weak var basketBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var basketButton: BasketButton!
    
    var cellModels: [CellModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
                
        let logoView = UINib(nibName: "NavbarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        logoView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 50)
        logoView.sizeToFit()
        self.navigationItem.titleView = logoView

        tableView.separatorStyle = .none
                
        output?.loadData()
    }
    
    @IBAction func openBasket() {
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
    
    func showBasketButton(show: Bool) {
        basketBottomConstraint.constant = show ? 15 : -100
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupPrice(priceString: NSAttributedString) {
        basketButton.infoLabel.attributedText = priceString
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
