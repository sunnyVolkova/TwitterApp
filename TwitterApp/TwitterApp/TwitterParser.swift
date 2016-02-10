//
//  TwitterParser.swift
//  TwitterApp
//
//  Created by RWuser on 29/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class Parser {
    static let tweetIdKey = "id"
    static let tweetTextKey = "text"
    static let tweetDateKey = "created_at"
    static let tweetUserKey = "user"
    static let tweetEntitiesKey = "entities"
    static let tweetCurrentUserRetweetIdKey = "current_user_retweet_id"
    static let tweetFavoriteCountKey = "favorite_count"
    static let tweetFavoritedKey = "favorited"
    static let tweetInReplyToScreenNameKey = "in_reply_to_screen_name"
    static let tweetInReplyToStatusIdKey = "in_reply_to_status_id"
    static let tweetInReplyToUserIdKey = "in_reply_to_user_id"
    static let tweetLangKey = "lang"
    static let tweetPossiblySensitiveKey = "possibly_sensitive"
    static let tweetQuotesStatusIdKey = "quotes_status_id"
    static let tweetRetweetCountKey = "retweet_count"
    static let tweetRetweetedKey = "retweeted"
    static let tweetTruncatedKey = "truncated"
    static let tweetRetweetedStatusKey = "retweeted_status"

    //date format
    static let dateFormat = "EEE' 'MMM' 'dd' 'HH':'mm':'ss' 'Z' 'yyyy"
    
    static func parseTwit(dictionary: [String: AnyObject]) -> Tweet {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: managedContext) as! Tweet


        let id = dictionary[tweetIdKey] as! NSNumber
        let text = dictionary[tweetTextKey] as! String
        let currentUserRetweetId = dictionary[tweetCurrentUserRetweetIdKey] as? NSNumber
        let favoriteCount = dictionary[tweetFavoriteCountKey] as? NSNumber
        let favorited = dictionary[tweetFavoritedKey] as? NSNumber
        let inReplyToScreenName = dictionary[tweetInReplyToScreenNameKey] as? String
        let inReplyToStatusId = dictionary[tweetInReplyToStatusIdKey] as? NSNumber
        let inReplyToUserId = dictionary[tweetInReplyToUserIdKey] as? NSNumber
        let lang = dictionary[tweetLangKey] as? String
        let possiblySensitive = dictionary[tweetPossiblySensitiveKey] as? NSNumber
        let quotesStatusId = dictionary[tweetQuotesStatusIdKey] as? NSNumber
        let retweetCount = dictionary[tweetRetweetCountKey] as? NSNumber
        let retweeted = dictionary[tweetRetweetedKey] as? NSNumber
        let truncated = dictionary[tweetTruncatedKey] as? NSNumber

        let dateString = dictionary[tweetDateKey] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.dateFromString(dateString)

        tweet.created_at = date
        tweet.current_user_retweet_id = currentUserRetweetId
        tweet.favorite_count = favoriteCount
        tweet.favorited = favorited
        tweet.id = id
        tweet.in_reply_to_screen_name = inReplyToScreenName
        tweet.in_reply_to_status_id = inReplyToStatusId
        tweet.in_reply_to_user_id = inReplyToUserId
        tweet.lang = lang
        tweet.possibly_sensitive = possiblySensitive
        tweet.quotes_status_id = quotesStatusId
        tweet.retweet_count = retweetCount
        tweet.retweeted = retweeted
        tweet.text = text
        tweet.truncated = truncated

        if let userDictionary = dictionary[tweetUserKey] as? [String: AnyObject] {
            let user = parseUser(userDictionary)
            tweet.user = user
        }
        
        if let entitiesDictionary = dictionary[tweetEntitiesKey] as? [AnyObject] {
            let entities = parseEntities(entitiesDictionary)
            tweet.entities = entities
        }

        if let retweetedStatusDictionary = dictionary[tweetRetweetedStatusKey] as? [String: AnyObject] {
            let retweetedStatus = parseTwit(retweetedStatusDictionary)
            tweet.retweeted_status = retweetedStatus
        }
        return tweet
    }
    
    static func parseTwitArray(array: [AnyObject]) -> [Tweet] {
        var tweetArray: [Tweet] = []
        for tweetDict in array{
            if let tweetDict = tweetDict as? [String: AnyObject] {
                let tweet = parseTwit(tweetDict)
                tweetArray.append(tweet)
            }
            
        }
        return tweetArray
    }
    
    static func parseTwitData(data: NSData) -> [Tweet]{
        let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        return parseTwitArray(jsonDict as! [Tweet])
    }
    
    
}