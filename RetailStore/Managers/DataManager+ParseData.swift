//
//  DataManager+ParseData.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/13/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import Foundation


extension DataManager {
    func parseStoreJSONData(jsonString:String) {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let jDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [[String:Any]] {
                    let store = Store(context: DataManager.sharedManager.container.viewContext)
                    for obj in jDict {
                        guard let name = obj["name"] as? String, let category = obj["category"] as? String, let imageUrl = obj["image"] as? String, let price = obj["price"] as? NSNumber, let uid = obj["UID"] as? Int16 else {
                            print("Error while parsing JSON \(#function)")
                            return
                        }
                        let item = Item(context: DataManager.sharedManager.container.viewContext)
                        item.uid = uid
                        item.price = price.floatValue
                        item.imageUrl = imageUrl
                        item.category = category
                        item.name = name
                        store.addToItems(item)
                    }
                    DataManager.sharedManager.saveContext()
                }
            } catch  {
                print("Error while parsing json \(#function) \nError:\(error)")
            }
            
        }
    }
}
