//
//  Symbol+CoreDataProperties.swift
//  TwitterApp
//
//  Created by RWuser on 12/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Symbol {

    @NSManaged var indices: NSObject?
    @NSManaged var text: String?
    @NSManaged var symbol_entity: Entity?

}
