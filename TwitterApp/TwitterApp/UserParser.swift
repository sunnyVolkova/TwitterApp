//
// Created by RWuser on 09/02/16.
// Copyright (c) 2016 RWuser. All rights reserved.
//

import UIKit
import CoreData
extension Parser {
    //user
    static let userNameKey = "name"
    static let userCreatedAtKey = "created_at"
    static let userFavouritesCountKey = "favourites_count"
    static let userFollowRequestSentKey = "follow_request_sent"
    static let userFollowersCountKey = "followers_count"
    static let userFollowingKey = "following"
    static let userUserDescriptionKey = "user_description"
    static let userFriendsCountKey = "friends_count"
    static let userGeoEnabledKey = "geo_enabled"
    static let userIdKey = "id"
    static let userLangKey = "lang"
    static let userLocationKey = "location"
    static let userProtectedKey = "protected"
    static let userScreenNameKey = "screen_name"
    static let userStatusesCountKey = "statuses_count"
    static let userTimeZoneKey = "time_zone"
    static let userVerifiedKey = "verified"
    static let userUtcOffsetKey = "utc_offset"
    static let userStatusKey = "status"
    static let userImageUrlKey = "profile_image_url"

    static func parseUser(dictionary: [String: AnyObject]) -> User {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedContext) as! User
        
        let id = dictionary[userIdKey] as? NSNumber
        let name = dictionary[userNameKey] as? String
        let favouritesCount = dictionary[userFavouritesCountKey] as? NSNumber
        let followRequestSent = dictionary[userFollowRequestSentKey] as? NSNumber
        let followersCount = dictionary[userFollowersCountKey] as? NSNumber
        let following = dictionary[userFollowingKey] as? NSNumber
        let userDescription = dictionary[userUserDescriptionKey] as? String
        let friendsCount = dictionary[userFriendsCountKey] as? NSNumber
        let geoEnabled = dictionary[userGeoEnabledKey] as? NSNumber
        let lang = dictionary[userLangKey] as? String
        let location = dictionary[userLocationKey] as? String
        let protected = dictionary[userProtectedKey] as? NSNumber
        let screenName = dictionary[userScreenNameKey] as? String
        let statusesCount = dictionary[userStatusesCountKey] as? NSNumber
        let timeZone = dictionary[userTimeZoneKey] as? String
        let verified = dictionary[userVerifiedKey] as? NSNumber
        let utcOffset = dictionary[userUtcOffsetKey] as? NSNumber
        let imageUrl = dictionary[userImageUrlKey] as? String

        user.id = id
        user.name = name
        user.favourites_count = favouritesCount
        user.follow_request_sent = followRequestSent
        user.followers_count = followersCount
        user.following = following
        user.user_description = userDescription
        user.friends_count = friendsCount
        user.geo_enabled = geoEnabled
        user.lang = lang
        user.location = location
        user.protected = protected
        user.screen_name = screenName
        user.statuses_count = statusesCount
        user.time_zone = timeZone
        user.verified = verified
        user.utc_offset = utcOffset
        user.profile_image_url = imageUrl

        if let statusDictionary = dictionary[userStatusKey] as? [String: AnyObject]{
            let status = parseTwit(statusDictionary)
            user.status = status
        }

        return user
    }

}