//
//  Hashtag+CoreDataProperties.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hashtag {

    @NSManaged var text: String?
    @NSManaged var indices: NSObject?

}
