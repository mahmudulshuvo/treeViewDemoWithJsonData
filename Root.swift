//
//  JsonObject.swift
//  TreeViewDemo
//
//  Created by Shuvo on 6/8/17.
//  Copyright © 2017 SHUVO. All rights reserved.
//

import Cocoa
import SwiftyJSON

class Root: NSObject {

    let name: String
    var children = [RootItem]()
    var value: JSON = nil
    var haveChild: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, value: JSON, haveChild: Bool) {
        self.name = name
        self.value = value
        self.haveChild = haveChild
        
    }
    
    class func createList(mainArr: [NSMutableDictionary]) -> [Root] {
        
        var rootObjects = [Root]()
        var rootItemChild = [RootItem]()
        var found:Bool = false
        
        for items in mainArr {
            found = false
            if ((items.value(forKey: "childOf") as! String ) == "root") {
                let name: String = items.value(forKey: "key") as! String
                let value: JSON = items.value(forKey: "value") as! JSON
                var newRootObj = Root(name: name, value: value, haveChild: false)
                if ((items.value(forKey: "value") as! JSON).count > 0) {
                    newRootObj = Root(name: name, value: value, haveChild: true)
                }
                rootObjects.append(newRootObj)
            }
            
            else {
                for rootItem in rootObjects {

                    if (rootItem.name == items.value(forKey: "childOf") as! String) {
                        found = true
                        let dic:NSMutableDictionary = [:]
                        dic.setValue(items.value(forKey: "key") as! String, forKey: "key")
                        dic.setValue(items.value(forKey: "value") as! JSON, forKey: "value")
                        dic.setValue(items.value(forKey: "childOf"), forKey: "childOf")
                        var itemChild = RootItem(dictionary: dic, haveChild: false)
                        
                        if ((items.value(forKey: "value") as! JSON).count > 0) {
                            itemChild = RootItem(dictionary: dic, haveChild: true)
                        }
                        
                        rootItemChild.append(itemChild)
                        rootItem.children.append(itemChild)
                    }
                }
                
                if (found == false) {
                    
                    var check:Bool = false
                    for rootItemChilds in rootItemChild {
                        if (rootItemChilds.key == items.value(forKey: "childOf") as! String) {
                            check = false
                            for (_, subJson) in rootItemChilds.value(forKey: "value") as! JSON{
                                if (subJson ==  items.value(forKey: "value") as! JSON){
                                    check = true
                                    break
                                }
                            }
                            if (check) {
                                found = true
                                let dic:NSMutableDictionary = [:]
                                dic.setValue(items.value(forKey: "key") as! String, forKey: "key")
                                dic.setValue(items.value(forKey: "value") as! JSON, forKey: "value")
                                dic.setValue(items.value(forKey: "childOf"), forKey: "childOf")
                                var itemChild = RootItem(dictionary: dic, haveChild: false)
                                
                                if ((items.value(forKey: "value") as! JSON).count > 0) {
                                    itemChild = RootItem(dictionary: dic, haveChild: true)
                                }
                                
                                rootItemChilds.rootItemsChild.append(itemChild)
                                rootItemChild.append(itemChild)
                            }
                        }
                    }
                }
            }
        }
        
        return rootObjects
    }
    
    class func createListArr(jsonData: JSON) -> [NSMutableDictionary] {
        
        var mainArr = [NSMutableDictionary]()
        var tempArr = [NSMutableDictionary]()
        var newArr = [NSMutableDictionary]()
        
        for(index, subJson):(String, JSON) in jsonData {
            
            let dic: NSMutableDictionary = [:]
            dic.setValue(index, forKey: "key")
            dic.setValue(subJson, forKey: "value")
            dic.setValue("root", forKey: "childOf")
            tempArr.append(dic)
        }
        
        mainArr = tempArr
        while (!tempArr.isEmpty) {
            
            var futureTempArr = [NSMutableDictionary]()
    
            for items in tempArr {
                newArr.append(items)
                let str: String = items.value(forKey: "key") as! String
            
                if ((items.value(forKey: "value") as! JSON).count > 0) {
                    
                    let json: JSON = items.value(forKey: "value") as! JSON
                    for (index, nestedJson) in json {
                        let dic: NSMutableDictionary = [:]
                        dic.setValue(index, forKey: "key")
                        dic.setValue(nestedJson, forKey: "value")
                        dic.setValue(str, forKey: "childOf")
                        futureTempArr.append(dic)
                    }
                }
            }
            
            tempArr = [NSMutableDictionary]()
            tempArr = futureTempArr
            futureTempArr = [NSMutableDictionary]()
            newArr = [NSMutableDictionary]()
            for items in tempArr {
                mainArr.append(items)
            }
        }
        return mainArr
    }

}
