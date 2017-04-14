//
//  DataManager.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/13/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import Foundation
import CoreData

open class DataManager {
    public static let sharedManager = DataManager()
    let modelName = "RetailStore"
    
    
    open lazy var container:NSPersistentContainer  = {
        let cont = NSPersistentContainer(name: self.modelName)
        cont.loadPersistentStores { (storeDesc, error) in
            if error != nil {
                print("Error while init Container")
            }
        }
        return cont
    }()
    
    open lazy var context: NSManagedObjectContext = {
        return self.container.viewContext
    }()
    
    open func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error while saving context \n Error: \(error)")
            }
        }
    }
}
