//
//  ViewController.swift
//  TreeViewDemo
//
//  Created by Shuvo on 6/8/17.
//  Copyright © 2017 SHUVO. All rights reserved.
//

import Cocoa
import WebKit
import SwiftyJSON

class ViewController: NSViewController {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet weak var webView: WebView!
    @IBOutlet var textView: NSTextView!
    
    var jsonData: JSON = []
    var rootObjects = [Root]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        jsonData = readJsonData()
        var mainArr = [NSMutableDictionary]()
        mainArr = Root.createRootItemsArr(jsonData: jsonData)
        rootObjects = Root.createRoot(mainArr: mainArr)
        print("Json feed: \(rootObjects)")
        outlineView.reloadData()
        
        //       print("My Main Array Dictionary: \(mainArr)")
        //       print("Total items: \(mainArr.count)")
        //        jsonFeeds = JsonObject.myList(jsonData: jsonData)
    }
    
    func readJsonData() -> JSON {
        let path = Bundle.main.path(forResource: "JsonFile", ofType:"json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!),
                                    options: NSData.ReadingOptions.uncached)
        let parseData = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        return parseData
    }
    
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        
        let item = sender.item(atRow: sender.clickedRow)
    
        if item is Root {
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
        
        else if item is RootItem {
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
            } else {
                sender.expandItem(item)
            }
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }
    
    override func deleteBackward(_ sender: Any?) {
        
        let selectedRow = outlineView.selectedRow
        if selectedRow == -1 {
            return
        }
        outlineView.beginUpdates()
        if let item = outlineView.item(atRow: selectedRow) {
            if let item = item as? Root {
                if let index = self.rootObjects.index( where: {$0.name == item.name} ) {
                    self.rootObjects.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
                }
            }
            
            else if let item = item as? RootItem {
                for rootObject in self.rootObjects {
                    if let index = rootObject.children.index( where: {$0.key == item.key} ) {
                        rootObject.children.remove(at: index)
                        outlineView.removeItems(at: IndexSet(integer: index), inParent: rootObject, withAnimation: .slideLeft)
                    }
                }
            }
        }
        
        outlineView.endUpdates()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let rootObject = item as? Root {
            return rootObject.children.count
        }
        
        else if let rootItems = item as? RootItem {
            return rootItems.rootItemsChild.count
        }
        return rootObjects.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let rootObject = item as? Root {
            return rootObject.children[index]
        }
        else if let rootItems = item as? RootItem {
            return rootItems.rootItemsChild[index]
        }
        return rootObjects[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let rootObject = item as? Root {
            return rootObject.children.count > 0
        }
        else if item is RootItem {
            return true
        }
        
        return false
    }
}

extension ViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let rootObject = item as? Root {
            if tableColumn?.identifier == "branchColumn" {
                view = outlineView.make(withIdentifier: "branchCell", owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    
                    if (rootObject.haveChild) {
                        textField.stringValue = "Branch"
                        textField.sizeToFit()
                    }
                    else {
                        textField.stringValue = "Leaf"
                        textField.sizeToFit()
                    }
                }
            } else {
                view = outlineView.make(withIdentifier: "rootCell", owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = rootObject.name
                    textField.sizeToFit()
                }
            }
        } else if let rootObjectItem = item as? RootItem {
            if tableColumn?.identifier == "branchColumn" {
                view = outlineView.make(withIdentifier: "branchCell", owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
                    
                    if (rootObjectItem.haveChild) {
                        textField.stringValue = "Branch"
                        textField.sizeToFit()
                    }
                    else {
                        textField.stringValue = "Leaf"
                        textField.sizeToFit()
                    }
                }
            } else {
                view = outlineView.make(withIdentifier: "rootItemCell", owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = rootObjectItem.key
                    textField.sizeToFit()
                }
            }
        }
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }

        let selectedIndex = outlineView.selectedRow
        
        if let rootObjectItem = outlineView.item(atRow: selectedIndex) as? RootItem {
            let value = String(describing: rootObjectItem.value)
            textView.string = value
        }
        
        else if let rootObject = outlineView.item(atRow: selectedIndex) as? Root {
            let value = String(describing: rootObject.value)
            textView.string = value
        }
        
        else {
            //Do nothing
            
        }
    }
}

