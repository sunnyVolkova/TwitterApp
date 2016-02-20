//
//  DataService.swift
//  TwitterApp
//
//  Created by RWuser on 11/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import CoreData

class DataService{
    static func parseAndStoreTwitData(data: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        parseAndStoreTwitData(data, managedContext: managedContext)
        
    }
    
    static func parseAndStoreSingleTwitData(data: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        parseAndStoreSingleTwitData(data, managedContext: managedContext)
        
    }
    
    static func parseAndStoreFoundStatuses(data: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        parseAndStoreFoundStatuses(data, managedContext: managedContext)
        
    }
    
    static func parseAndStoreFoundStatuses(data: NSData, managedContext: NSManagedObjectContext) {
        let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        childContext.parentContext = managedContext
        do {
            if let response = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                if let tweetArray = response!["statuses"] as? [AnyObject] {
                    for tweetDict in tweetArray {
                        if let tweetDict = tweetDict as? [String: AnyObject] {
                            let id = tweetDict[Tweet.tweetIdKey] as! Int
                            let tweet = Tweet.objectForTweet(childContext, tweetId: id)
                            tweet.dataFromDictionary(tweetDict, managedContext: childContext)
                        }
                    }
                }
            }
            try childContext.save()
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func parseAndStoreTwitData(data: NSData, managedContext: NSManagedObjectContext) {
        let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        childContext.parentContext = managedContext
        do {
            if let tweetArray = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [AnyObject] {
                for tweetDict in tweetArray {
                    if let tweetDict = tweetDict as? [String: AnyObject] {
                        let id = tweetDict[Tweet.tweetIdKey] as! Int
                        let tweet = Tweet.objectForTweet(childContext, tweetId: id)
                        tweet.dataFromDictionary(tweetDict, managedContext: childContext)
                    }
                }
            }
            try childContext.save()
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func parseAndStoreSingleTwitData(data: NSData, managedContext: NSManagedObjectContext) {
        let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        childContext.parentContext = managedContext
        
        if let tweetDict = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                                 NSLog("data: \(tweetDict)")
            let id = tweetDict![Tweet.tweetIdKey] as! Int
            let tweet = Tweet.objectForTweet(childContext, tweetId: id)
            tweet.dataFromDictionary(tweetDict!, managedContext: childContext)
        }
        do {
            try childContext.save()
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func getTweetsFromCoreData() -> [Tweet]?{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName:"Tweet")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            let results =
            try managedContext.executeFetchRequest(request) as! [Tweet]
            return results
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    static func getMyRetweetIdsForTweet(tweetId tweetId: NSNumber) -> [NSNumber]?{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        return getMyRetweetIdsForTweet(tweetId: tweetId, managedContext: managedContext)
    }
    
    static func getMyRetweetIdsForTweet(tweetId tweetId: NSNumber, managedContext: NSManagedObjectContext) -> [NSNumber]?{
        let request = NSFetchRequest(entityName: "Tweet")
        let predicate = NSPredicate(format: "retweeted_status.id == \(tweetId)")
        request.predicate = predicate
        do {
            var resultIds = [NSNumber]()
            let results =
            try managedContext.executeFetchRequest(request) as! [Tweet]
            for tweet in results {
                resultIds.append(tweet.id!)
            }
            return resultIds
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    static func removeTweetsWithIdsFromCoreData(tweetIds: [NSNumber]){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        return removeTweetsWithIdsFromCoreData(tweetIds, managedContext: managedContext)
    }
    
    static func removeTweetsWithIdsFromCoreData(tweetIds: [NSNumber], managedContext: NSManagedObjectContext){
        do {
            for tweetId in tweetIds {
                let request = NSFetchRequest(entityName:"Tweet")
                let predicate = NSPredicate(format: "id == \(tweetId)")
                request.predicate = predicate
                
                let results = try managedContext.executeFetchRequest(request)
                for object in results {
                    managedContext.deleteObject(object as! NSManagedObject)
                }
            }
            try managedContext.save()
        } catch let error as NSError {
            NSLog("Could not delete objects \(error), \(error.userInfo)")
        }
    }
}
