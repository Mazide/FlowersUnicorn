//
//  BasketService.swift
//  FlowersUnicorn
//
//  Created by Home on 03/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

typealias BasketChangeHandler = () -> Void

class BasketService: NSObject {
    private var ids = NSMutableSet()

    static let shared = BasketService()
    
    var basketChangeHandler: BasketChangeHandler?
    
    override init() {
        super.init()
        if let idsArray = UserDefaults.standard.array(forKey: "BasketServiceKey") as? [String] {
            self.ids = NSMutableSet.init(array: idsArray)
        }
    }

    func clear() {
        ids.removeAllObjects()
        
        UserDefaults.standard.set(nil, forKey: "BasketServiceKey")
        UserDefaults.standard.synchronize()
    }
    
    func add(id: String) {
        guard id.count != 0 else {
            return
        }
        ids.add(id)
        save()
    }
    
    func remove(id: String) {
        ids.remove(id)
        save()
    }
    
    func isContain(id: String) -> Bool {
        guard id.count != 0 else {
            return false
        }
        return ids.contains(id)
    }
    
    func addedIds() -> [String] {
        return ids.allObjects as! [String]
    }
    
    func save() {
        basketChangeHandler?()
        UserDefaults.standard.set(ids.allObjects, forKey: "BasketServiceKey")
        UserDefaults.standard.synchronize()
    }
    
}
