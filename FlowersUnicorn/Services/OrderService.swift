//
//  OrderService.swift
//  FlowersUnicorn
//
//  Created by Nikita Demidov on 11.04.2020.
//  Copyright © 2020 Nikita Demidov. All rights reserved.
//

import UIKit

class OrderService: NSObject {


    func makeOrder(order: BasketOrderModel, allItems:[CatalogItem], completion: @escaping (_ success: Bool, _ error: Error?) -> Void)  {
        guard let url = URL.init(string: "http://maaakso.ru/FU/new-order/") else {
            return
        }
        var request = try! URLRequest.init(url: url, method: .post)
        var parameters = [String : String]()

        var products = ""
        for (key, count) in order.itemCounts {
            if let title = allItems.filter({ item in
                return item.id == key
            }).first?.title {
                products += title + ":" + String(count) + "\n"
            }
        }

        parameters["products"] = products
        parameters["delivery"] = order.delivery?.title ?? ""
        parameters["total_price"] = order.totalPrice ?? ""
        parameters["name"] = order.name ?? ""
        parameters["phone"] = order.phone ?? ""
        parameters["date"] = order.date?.description ?? ""
        parameters["comment"] = order.comment
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }

        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            completion(error == nil, error)
        }.resume()
    }
}
