//
//  BasketDatePicker.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketDatePicker: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var doneHandler: ((Date) -> Void)?
    
    @IBAction func done() {
        doneHandler?(datePicker.date)
    }
}
