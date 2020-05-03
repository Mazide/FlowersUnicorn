//
//  SuccessOrderViewController.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 18.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class SuccessOrderViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var blurView: UIView!

    var doneHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.alpha = 0
        blurView.alpha = 0
        self.view.backgroundColor = UIColor.clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        containerView.layer.cornerRadius = 14

        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1
            self.blurView.alpha = 1
        }
    }

    @IBAction func close() {
        doneHandler?()
    }
}
