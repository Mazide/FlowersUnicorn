//
//  BasketService.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

class BasketService: NSObject {
    private var ids = NSMutableSet()

    static let shared = BasketService()
    
    override init() {
        super.init()
        if let idsArray = UserDefaults.standard.array(forKey: "BasketServiceKey") as? [String] {
            self.ids = NSMutableSet.init(array: idsArray)
        }
    }
    
    func add(id: String) {
        ids.add(id)
        save()
    }
    
    func remove(id: String) {
        ids.remove(id)
    }
    
    func isContain(id: String) -> Bool {
        return ids.contains(id)
    }
    
    func addedIds() -> [String] {
        return ids.allObjects as! [String]
    }
    
    func save() {
        UserDefaults.standard.set(ids.allObjects, forKey: "BasketServiceKey")
        UserDefaults.standard.synchronize()
    }
}
