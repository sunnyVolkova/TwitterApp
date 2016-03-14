//
//  ExtendedEntity.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class ExtendedEntity: NSManagedObject {
    static let entityName = "ExtendedEntity"
    
    static let mediaKey = "media"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForEntity(managedContext: NSManagedObjectContext, tweetId: Int) -> ExtendedEntity {
        var entity: ExtendedEntity
        var results: [ExtendedEntity]? = nil
        let predicate = NSPredicate(format: "tweet.id = \(tweetId)")
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            results = try managedContext.executeFetchRequest(request) as? [ExtendedEntity]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        
        if results != nil && results?.count > 0 {
            entity = results![0]
        } else {
            entity = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! ExtendedEntity
        }
        return entity
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        if let mediaArray = dictionary[Entity.mediaKey] as? [AnyObject] {
            self.media = Entity.parseArrayOfObjects(mediaArray, parseFunction: Media.getObjectForDictionary, managedContext: managedContext)
        }
    }
    
    
    static func getExtendedEntityForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext, tweetId: Int) -> ExtendedEntity? {
        let entity = ExtendedEntity.objectForEntity(managedContext, tweetId: tweetId)
        entity.dataFromDictionary(dictionary, managedContext: managedContext)
        return entity
    }
}
