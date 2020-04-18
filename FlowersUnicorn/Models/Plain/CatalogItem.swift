//
//  CatalogItem.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CatalogItem {
    let id: String
    let imagePath: String
    let price: Float
    let title: String
    let fullDescription: String
    
    init(dict: [String: Any]) {
        let json = JSON(dict)
        id = json["-id"].stringValue
        imagePath = json["picture"].stringValue
        price = json["price"].floatValue
        title = json["name"].stringValue
        fullDescription = json["description"].stringValue
    }
}
