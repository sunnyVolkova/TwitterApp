//
//  Tweet.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import CoreData

class Tweet: NSManagedObject{
    static let entityName = "Tweet"
    //date format
    static let dateFormat = "EEE' 'MMM' 'dd' 'HH':'mm':'ss' 'Z' 'yyyy"
    
    static let tweetIdKey = "id"
    static let tweetDateKey = "created_at"
    static let tweetUserKey = "user"
    static let tweetEntitiesKey = "entities"
    static let tweetRetweetedStatusKey = "retweeted_status"
    static let tweetExtendedEntitiesKey = "extended_entities"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForTweet(managedContext: NSManagedObjectContext, tweetId: Int) -> Tweet {
        var tweet: Tweet
        var results: [Tweet]? = nil
        let predicate = NSPredicate(format: "id = \(tweetId)")
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            results = try managedContext.executeFetchRequest(request) as? [Tweet]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }

        if results != nil && results?.count > 0 {
            tweet = results![0]
        } else {
            tweet = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Tweet
        }
        return tweet
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        let tweetId = dictionary[Tweet.tweetIdKey] as? Int
        for(key, value) in dictionary{
            let keyName = key as String
            let keyValue = value as? String
            if (self.respondsToSelector(NSSelectorFromString(keyName))){
                switch key {
                case Tweet.tweetDateKey:
                if let date = Tweet.dateFromString(keyValue!){
                    self.setValue(date, forKey: keyName)
                }
                case Tweet.tweetUserKey:
                    if let userDictionary  = value as? [String: AnyObject] {
                        let user = User.getUserForDictionary(userDictionary, managedContext: managedContext)
                        self.setValue(user, forKey: keyName)
                    }
                case Tweet.tweetEntitiesKey:
                    if let entitiesDictionary  = value as? [String: AnyObject] {
                        if tweetId != nil {
                            let entity = Entity.getEntityForDictionary(entitiesDictionary, managedContext: managedContext, tweetId: tweetId!)
                            self.setValue(entity, forKey: keyName)
                        }
                    }
                case Tweet.tweetRetweetedStatusKey:
                    NSLog("skip status parsing")
                case Tweet.tweetExtendedEntitiesKey:
                    if let extendedEntitiesDictionary = value as? [String: AnyObject] {
                        if tweetId != nil {
                            let extendedEntity = ExtendedEntity.getExtendedEntityForDictionary(extendedEntitiesDictionary, managedContext: managedContext, tweetId: tweetId!)
                            self.setValue(extendedEntity, forKey: keyName)
                        }
                    }
                default:
                    if !(value is NSNull) {
                        self.setValue(value, forKey: keyName)
                    }
                }
            }
        }
    }
    
    static func dateFromString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Tweet.dateFormat
        let date = dateFormatter.dateFromString(dateString)
        return date
    }
    
    static func getTweetForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> Tweet? {
        if let id = dictionary[Tweet.tweetIdKey] as? Int{
            let tweet = Tweet.objectForTweet(managedContext, tweetId: id)
            tweet.dataFromDictionary(dictionary, managedContext: managedContext)
            return tweet
        }
        return nil
    }
}
