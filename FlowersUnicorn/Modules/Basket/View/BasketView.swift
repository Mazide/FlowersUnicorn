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
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    
    var output: BasketViewOutput!
    var cellModels: [CellModel]?
    var dismissHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.separatorColor = .clear

        output.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissHandler?()
    }
    

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomConstaint?.constant = 0.0
            } else {
                self.bottomConstaint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }

}

extension BasketView: BasketViewInput {
    func setup(cellModels: [CellModel]) {
        tableView.isHidden = cellModels.count == 0

        for cellModel in cellModels {
            let nib = UINib.init(nibName: cellModel.cellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellModel.cellId)
        }
        
        self.cellModels = cellModels
        self.tableView.reloadData()
    }

    func showError() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
        alertVC.addAction(.init(title: "ОК", style: .cancel))
        present(alertVC, animated: true)
    }

    func endEditing() {
        view.endEditing(true)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
