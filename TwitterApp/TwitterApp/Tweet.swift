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
    static let tweetReplyToStatusIdKey = "in_reply_to_status_id"
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    static func getTweetById(managedContext: NSManagedObjectContext, tweetId: Int) -> Tweet? {
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
            return results![0]
        } else {
            return nil
        }
    }
    
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
                    if let tweetDictionary = value as? [String: AnyObject] {
                        if tweetId != nil {
                            let tweet = Tweet.getTweetForDictionary(tweetDictionary, managedContext: managedContext)
                            self.setValue(tweet, forKey: keyName)
                        }
                    }
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

        if let in_reply_to_status_id = self.in_reply_to_status_id {
            if (in_reply_to_status_id as Int > 0){
                let tweet = Tweet.objectForTweet(managedContext, tweetId: in_reply_to_status_id as Int)
                tweet.id = in_reply_to_status_id
                self.reply_to_status = tweet
                self.setValue(tweet, forKey: "self.reply_to_status")
            }
        }
    }
    
    static func dateFromString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Tweet.dateFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
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
    
    static func fillReplies(managedContext: NSManagedObjectContext, tweetId: NSNumber){
        let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        childContext.parentContext = managedContext
        
        let tweetRequest = NSFetchRequest(entityName: Tweet.entityName)
        tweetRequest.predicate = NSPredicate(format :"id == \(tweetId)")
        var tweetResults: [Tweet]? = nil
        do {
            tweetResults = try childContext.executeFetchRequest(tweetRequest) as? [Tweet]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        
        if tweetResults != nil && tweetResults?.count > 0 {
            let twetToUpdate = tweetResults![0]
            
            let repliesRequest = NSFetchRequest(entityName: Tweet.entityName)
            repliesRequest.predicate = NSPredicate(format :"in_reply_to_status_id == \(tweetId)")
            var repliesResults: [Tweet]? = nil
            do {
                repliesResults = try childContext.executeFetchRequest(repliesRequest) as? [Tweet]
            } catch let error as NSError {
                NSLog("Could not fetch \(error), \(error.userInfo)")
            }
            
            if repliesResults != nil && repliesResults?.count > 0 {
                let replies = NSSet(array: repliesResults!)
                twetToUpdate.replies = replies
                for tweetObj in replies {
                    if let tweet = tweetObj as? Tweet {
                        fillReplies(childContext, tweetId: tweet.id!)
                    }
                }
            }
            do {
                try childContext.save()
            } catch let error as NSError {
                NSLog("Could not update objects \(error), \(error.userInfo)")
            }
        }
    }
    
    static func getRepliesToShow(tweet: Tweet) -> [Tweet]? {
        var replies = [Tweet]()
        if tweet.replies != nil {
            for reply in tweet.replies! {
                replies.append(reply as! Tweet)
                if let addReplies = getRepliesToShow(reply as! Tweet) {
                    replies.appendContentsOf(addReplies)
                }
            }
            return replies
        } else {
            return nil
        }
    }
    
    static func getRepliesToShowOnHome(tweet: Tweet) -> [Tweet]? {
        var replies = [Tweet]()
        if tweet.replies != nil {
            for reply in tweet.replies! {
                if let reply = reply as? Tweet {
                    if(reply.user!.following as! Int > 0 || reply.user!.id == LoginService.getCurrentUserId()!) {
                        replies.append(reply)
                        if let addReplies = getRepliesToShow(reply) {
                            replies.appendContentsOf(addReplies)
                        }
                    }
                }
            }
            return replies
        } else {
            return nil
        }
    }
}
