//
//  DestinationsService.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

struct DeliverSpot {
    let id: Int
    let title: String
    let price: Int
}

class DeliveryService: NSObject {
    func obtainDeliveriesSpots(completion: ([DeliverSpot]) -> Void) {
        let areas = [
            DeliverSpot(id: 0, title: "Самовывоз Москва", price: 0),
            DeliverSpot(id: 1, title: "Доставка по Москве", price: 500),
            DeliverSpot(id: 2, title: "Самовывоз Санкт-Петербург", price: 0),
            DeliverSpot(id: 3, title: "Доставка Санкт-Петербург", price: 500),
            DeliverSpot(id: 4, title: "Доставка по России", price: 1000),
        ]
        
        completion(areas)
    }
}
