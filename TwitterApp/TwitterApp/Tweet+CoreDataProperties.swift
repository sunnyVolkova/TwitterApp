//
//  Tweet+CoreDataProperties.swift
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

extension Tweet {

    @NSManaged var coordinates: NSObject?
    @NSManaged var created_at: NSDate?
    @NSManaged var current_user_retweet_id: NSNumber?
    @NSManaged var favorite_count: NSNumber?
    @NSManaged var favorited: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var in_reply_to_screen_name: String?
    @NSManaged var in_reply_to_status_id: NSNumber?
    @NSManaged var in_reply_to_user_id: NSNumber?
    @NSManaged var lang: String?
    @NSManaged var possibly_sensitive_appealable: NSNumber?
    @NSManaged var quotes_status_id: NSNumber?
    @NSManaged var retweet_count: NSNumber?
    @NSManaged var retweeted: NSNumber?
    @NSManaged var text: String?
    @NSManaged var truncated: NSNumber?
    @NSManaged var entities: Entity?
    @NSManaged var extended_entities: ExtendedEntity?
    @NSManaged var retweeted_status: Tweet?
    @NSManaged var user: User?

}
