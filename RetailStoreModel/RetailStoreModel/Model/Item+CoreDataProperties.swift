//
//  Item+CoreDataProperties.swift
//  RetailStoreModel
//
//  Created by Alfred Reynold on 4/14/17.
//  Copyright © 2017 Alfred Reynold. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var category: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var uid: Int16
    @NSManaged public var user: User?

}
