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
    func obtainCatalogItems(completion: @escaping ([CatalogItem]) -> Void) {
        guard let path = Bundle.main.path(forResource: "test", ofType: "json") else {
            return
        }
        
        guard let jsonData = NSData.init(contentsOfFile: path) as Data? else {
            return
        }
        
        do {
            let json: JSON = try JSON.init(data: jsonData )
            if let items = json["yml_catalog"]["shop"]["offers"]["offer"].array?.map({ (json) -> CatalogItem in
                return CatalogItem.init(dict: json.dictionaryValue)
            }) {
                completion(items);
            }
        } catch {
            print("parsing error")
        }
    }
}
