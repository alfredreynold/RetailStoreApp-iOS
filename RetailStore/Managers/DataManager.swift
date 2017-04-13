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
    static let sharedManager = DataManager()
    let modelName = "RetailStore"
    
    
    lazy var container:NSPersistentContainer  = {
        let cont = NSPersistentContainer(name: self.modelName)
        cont.loadPersistentStores { (storeDesc, error) in
            if error != nil {
                print("Error while init Container")
            }
        }
        return cont
    }()
    
    lazy var context: NSManagedObjectContext = {
        return self.container.viewContext
    }()
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error while saving context \n Error: \(error)")
            }
        }
    }
}
