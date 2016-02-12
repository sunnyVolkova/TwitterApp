//
//  Entity.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class Entity: NSManagedObject {
    static let entityName = "Entity"
    
    static let mediaKey = "media"
    static let urlsKey = "urls"
    static let userMentionsKey = "user_mentions"
    static let hashtagsKey = "hashtags"
    static let symbolsKey = "symbols"
    static let extendedEntitiesKey = "extended_entities"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForEntity(managedContext: NSManagedObjectContext, tweetId: Int) -> Entity {
        var entity: Entity
        var results: [Entity]? = nil
        let predicate = NSPredicate(format: "tweet.id = \(tweetId)")
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            results = try managedContext.executeFetchRequest(request) as? [Entity]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        
        if results != nil && results?.count > 0 {
            entity = results![0]
        } else {
            entity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Entity
        }
        return entity
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        if let mediaArray = dictionary[Entity.mediaKey] as? [AnyObject] {
            self.media = Entity.parseArrayOfObjects(mediaArray, parseFunction: Media.getObjectForDictionary, managedContext: managedContext)
        }
        if let symbolArray = dictionary[Entity.symbolsKey] as? [AnyObject] {
            self.symbols = Entity.parseArrayOfObjects(symbolArray, parseFunction: Symbol.getObjectForDictionary, managedContext: managedContext)
        }
        if let urlArray = dictionary[Entity.urlsKey] as? [AnyObject] {
            self.urls = Entity.parseArrayOfObjects(urlArray, parseFunction: Url.getObjectForDictionary, managedContext: managedContext)
        }
        if let userMentionsArray = dictionary[Entity.userMentionsKey] as? [AnyObject] {
            self.user_mentions = Entity.parseArrayOfObjects(userMentionsArray, parseFunction: UserMention.getObjectForDictionary, managedContext: managedContext)
        }
        if let hashtagsArray = dictionary[Entity.hashtagsKey] as? [AnyObject] {
            self.hashtags = Entity.parseArrayOfObjects(hashtagsArray, parseFunction: Hashtag.getObjectForDictionary, managedContext: managedContext)
        }
    }
    
    static func parseArrayOfObjects(array: [AnyObject], parseFunction: ([String: AnyObject], managedContext: NSManagedObjectContext) -> AnyObject, managedContext: NSManagedObjectContext) -> NSSet {
        let objectsArray = NSMutableSet()
        for objectDict in array{
            if let objectDict = objectDict as? [String: AnyObject] {
                let object = parseFunction(objectDict, managedContext: managedContext)
                objectsArray.addObject(object)
            }
        }
        return objectsArray
    }
    
    static func getEntityForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext, tweetId: Int) -> Entity? {
        let entity = Entity.objectForEntity(managedContext, tweetId: tweetId)
        entity.dataFromDictionary(dictionary, managedContext: managedContext)
        return entity
    }
}
