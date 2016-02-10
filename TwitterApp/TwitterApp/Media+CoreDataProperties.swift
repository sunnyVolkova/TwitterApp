//
//  Media+CoreDataProperties.swift
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

extension Media {

    @NSManaged var id: NSNumber?
    @NSManaged var media_url: String?
    @NSManaged var media_url_https: String?
    @NSManaged var display_url: String?
    @NSManaged var sizes: NSObject?
    @NSManaged var type: NSObject?
    @NSManaged var indices: NSObject?

}
