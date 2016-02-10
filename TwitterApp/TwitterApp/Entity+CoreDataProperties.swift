//
//  Entity+CoreDataProperties.swift
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

extension Entity {

    @NSManaged var media: NSSet?
    @NSManaged var urls: NSSet?
    @NSManaged var user_mentions: NSSet?
    @NSManaged var hashtags: NSSet?
    @NSManaged var symbols: NSSet?
    @NSManaged var extended_entities: NSSet?

}
