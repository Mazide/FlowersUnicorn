//
//  CatalogService.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import SwiftyJSON

class CatalogService: NSObject {
    var items: [CatalogItem]?

    func obtainCatalogItems(completion: @escaping ([CatalogItem]) -> Void) {
        let url = URL.init(string: "http://maaakso.ru/feed.json")!
        URLSession.shared.dataTask(with: url) { (jsonData, response, error) in
            guard let jsonData = jsonData else {
                return
            }
            
            let json: JSON = try! JSON.init(data: jsonData )
            if let items = json["yml_catalog"]["shop"]["offers"]["offer"].array?.map({ (json) -> CatalogItem in
                return CatalogItem.init(dict: json.dictionaryValue)
            }) {
                self.items = items
                DispatchQueue.main.async {
                    completion(items);
                }
            }
        }.resume()
    }
}
