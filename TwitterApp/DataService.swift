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
    static let timelineGotNotificationName = "timelineGotNotification"
    static func parseAndStoreTwitData(data: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        parseAndStoreTwitData(data, managedContext: managedContext)
        
    }
    
    
    static func parseAndStoreTwitData(data: NSData, managedContext: NSManagedObjectContext) {
        let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        childContext.parentContext = managedContext
        
        if let tweetArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [AnyObject] {
            for tweetDict in tweetArray! {
                if let tweetDict = tweetDict as? [String: AnyObject] {
                    let id = tweetDict[Tweet.tweetIdKey] as! Int
                    let tweet = Tweet.objectForTweet(childContext, tweetId: id)
                    tweet.dataFromDictionary(tweetDict, managedContext: childContext)
                }
            }
        }
        do {
            try childContext.save()
            try managedContext.save()
            NSNotificationCenter.defaultCenter().postNotificationName(timelineGotNotificationName, object: nil)

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
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
}
