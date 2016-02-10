//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var created_at: NSDate?
    @NSManaged var default_profile: NSNumber?
    @NSManaged var default_profile_image: NSNumber?
    @NSManaged var favourites_count: NSNumber?
    @NSManaged var follow_request_sent: NSNumber?
    @NSManaged var followers_count: NSNumber?
    @NSManaged var following: NSNumber?
    @NSManaged var user_description: String?
    @NSManaged var friends_count: NSNumber?
    @NSManaged var geo_enabled: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var lang: String?
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var profile_image_url: String?
    @NSManaged var protected: NSNumber?
    @NSManaged var screen_name: String?
    @NSManaged var statuses_count: NSNumber?
    @NSManaged var time_zone: String?
    @NSManaged var verified: NSNumber?
    @NSManaged var utc_offset: NSNumber?
    @NSManaged var entities: NSSet?
    @NSManaged var status: NSManagedObject?
    @NSManaged var statuses: NSSet?

}
