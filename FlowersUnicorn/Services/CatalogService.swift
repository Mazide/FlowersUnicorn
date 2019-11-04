//
//  CatalogService.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CatalogService: NSObject {
    func obtainCatalogItems(completion: @escaping ([CatalogItem]) -> Void) {
        let db = Firestore.firestore()
        db.collection("Catalog").getDocuments { (querySnapshot, err) in
           if let err = err {
               print("Error getting documents: \(err)")
                return
           }
            
            let catalogs = querySnapshot!.documents.map { (document) -> CatalogItem in
                let catalogItem = CatalogItem(dict: document.data())
                return catalogItem
            }
        
            completion(catalogs)
        }
    }
}
