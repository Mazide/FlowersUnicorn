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
    var refreshControl = UIRefreshControl()

    var cellModels: [CellModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .automatic

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        output?.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logoView = UINib(nibName: "NavbarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTitleView
        logoView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 50)
        logoView.sizeToFit()
        self.navigationItem.titleView = logoView
        
        let supportButton = UIButton()
        let supportIcon = UIImage(named: "support")
        supportButton.setBackgroundImage(supportIcon, for: .normal)
        supportButton.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
        let supportButtonItem = UIBarButtonItem.init(customView: supportButton)
        
        self.navigationItem.rightBarButtonItem = supportButtonItem
        
        tableView.separatorStyle = .none

        output?.loadData()


    }
    
    @IBAction func openBasket() {
        output?.didTapBasket()
    }
    
    @objc func openInfo() {
        let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let showInfoAction = UIAlertAction.init(title: "Доставка и контакты", style: .default) { [weak self] (_) in
            let infoViewController = ContactsViewController.init(nibName: "ContactsViewController", bundle: nil)
            self?.present(infoViewController, animated: true, completion: nil)
        }
                    
        let showWhatsAppMoskow = UIAlertAction.init(title: "Москва WhatsApp", style: .default) { (_) in
            let botURL = URL.init(string: "whatsapp://send/?phone=79313764695&text")

            if UIApplication.shared.canOpenURL(botURL!) {
                UIApplication.shared.open(botURL!, options: [:], completionHandler: nil)
            }
        }
        
        let showWhatsAppSpb = UIAlertAction.init(title: "Санкт-Петербург WhatsApp", style: .default) { (_) in
            let botURL = URL.init(string: "whatsapp://send/?phone=79095796196&text")

            if UIApplication.shared.canOpenURL(botURL!) {
                UIApplication.shared.open(botURL!, options: [:], completionHandler: nil)
            }
        }

        
        let cancel = UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil)
        
        alertVC.addAction(showInfoAction)
        alertVC.addAction(showWhatsAppMoskow)
        alertVC.addAction(showWhatsAppSpb)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true, completion: nil)
    }
}

extension CatalogView: CatalogViewInput {
    
    func setup(cellModels: [CellModel]) {
        refreshControl.endRefreshing()

        DispatchQueue.main.async {
            for cellModel in cellModels {
                let nib = UINib.init(nibName: cellModel.cellId, bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: cellModel.cellId)
            }
            
            self.cellModels = cellModels
            self.tableView.reloadData()
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellModel = cellModels?[indexPath.row] else {
            fatalError("Cell models isn't exist")
        }
        if let configurableCell = cell as? CatalogTableViewCell {
            configurableCell.configure(with: cellModel)
        }
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
