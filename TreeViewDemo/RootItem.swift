//
//  JsonObjectItems.swift
//  TreeViewDemo
//
//  Created by Shuvo on 6/8/17.
//  Copyright © 2017 SHUVO. All rights reserved.
//

import Cocoa

class RootItem: NSObject {
    
    let key: String
    let value: Any
    let childOf: String
    let haveChild: Bool
    var rootItemsChild = [RootItem]()
    
//    init(dictionary: NSDictionary) {
//        self.key = dictionary.object(forKey: "key") as! String
//        self.value = dictionary.object(forKey: "value") as Any
//        self.childOf = dictionary.object(forKey: "childOf") as! String
//        self.jsonItemsChild = dictionary.object(forKey: "haveChild") as! [JsonObjectItems]
//    }
    
    init(dictionary: NSDictionary, haveChild: Bool) {
        self.key = dictionary.object(forKey: "key") as! String
        self.value = dictionary.object(forKey: "value") as Any
        self.childOf = dictionary.object(forKey: "childOf") as! String
        self.haveChild = haveChild
    }
    
}
