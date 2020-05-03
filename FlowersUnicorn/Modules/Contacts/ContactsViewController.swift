//
//  ContactsViewController.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 19.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBAction func callMoskow() {
        let phoneNumber = "telprompt://+79313764695"
        let phoneURL = URL.init(string: phoneNumber)!
        UIApplication.shared.open(phoneURL)
    }
    
    @IBAction func callSpb() {
        let phoneNumber = "telprompt://+79095796196"
        let phoneURL = URL.init(string: phoneNumber)!
        UIApplication.shared.open(phoneURL)
    }
}
