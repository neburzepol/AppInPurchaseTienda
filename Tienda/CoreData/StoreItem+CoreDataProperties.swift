//
//  StoreItem+CoreDataProperties.swift
//  Tienda
//
//  Created by Ali Lopez Galaviz on 04/12/18.
//  Copyright © 2018 Ali López Galaviz. All rights reserved.
//
//

import Foundation
import CoreData


extension StoreItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreItem> {
        return NSFetchRequest<StoreItem>(entityName: "StoreItem")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var productIdentifier: String?
    @NSManaged public var purchased: Bool
    @NSManaged public var title: String?

}
