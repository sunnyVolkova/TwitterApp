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
        } catch let error as NSError {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
        
    }
}
