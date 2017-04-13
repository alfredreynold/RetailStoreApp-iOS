//
//  Item+CoreDataProperties.swift
//  RetailStore
//
//  Created by Alfred Reynold on 4/13/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var category: Int16

}
