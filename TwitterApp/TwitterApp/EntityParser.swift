//
// Created by RWuser on 09/02/16.
// Copyright (c) 2016 RWuser. All rights reserved.
//

import UIKit
import CoreData

extension Parser{
    //extended entities
    static let idKey = "id"
    static let mediaUrlKey = "media_url"
    static let displayUrlKey = "display_url"
    static let expandedUrlKey = "expanded_url"
    static let urlKey = "url"
    static let typeKey = "type"
    static let indicesKey = "indices"
    static let textKey = "text"
    static let screenNameKey = "screen_name"
    static let nameKey = "name"

    static let mediaKey = "media"
    static let urlsKey = "urls"
    static let userMentionsKey = "user_mentions"
    static let hashtagsKey = "hashtags"
    static let symbolsKey = "symbols"
    static let extendedEntitiesKey = "extended_entities"

    static func parseExtendedEntity(dictionary: [String: AnyObject]) -> ExtendedEntity {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let extendedEntity = NSEntityDescription.insertNewObjectForEntityForName("ExtendedEntity", inManagedObjectContext: managedContext) as! ExtendedEntity

        extendedEntity.id = dictionary[idKey] as? NSNumber
        extendedEntity.media_url = dictionary[mediaUrlKey] as? String
        extendedEntity.display_url = dictionary[displayUrlKey] as? String
        extendedEntity.type = dictionary[typeKey] as? NSObject
        extendedEntity.indices = dictionary[indicesKey] as? NSObject
        return extendedEntity
    }


    static func parseMedia(dictionary: [String: AnyObject]) -> Media {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let media = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: managedContext) as! Media

        media.media_url = dictionary[mediaUrlKey] as? String
        media.display_url = dictionary[displayUrlKey] as? String
        media.type = dictionary[typeKey] as? NSObject
        media.indices = dictionary[indicesKey] as? NSObject
        return media
    }

    static func parseSymbol(dictionary: [String: AnyObject]) -> Symbol {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let symbol = NSEntityDescription.insertNewObjectForEntityForName("Symbol", inManagedObjectContext: managedContext) as! Symbol

        symbol.text = dictionary[textKey] as? String
        symbol.indices = dictionary[indicesKey] as? NSObject
        return symbol
    }

    static func parseHashtag(dictionary: [String: AnyObject]) -> Hashtag {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let hashtag = NSEntityDescription.insertNewObjectForEntityForName("Hashtag", inManagedObjectContext: managedContext) as! Hashtag

        hashtag.text = dictionary[textKey] as? String
        hashtag.indices = dictionary[indicesKey] as? NSObject
        return hashtag
    }

    static func parseUserMention(dictionary: [String: AnyObject]) -> UserMention {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let userMention = NSEntityDescription.insertNewObjectForEntityForName("UserMention", inManagedObjectContext: managedContext) as! UserMention

        userMention.id = dictionary[idKey] as? NSNumber
        userMention.name = dictionary[nameKey] as? String
        userMention.screen_name = dictionary[screenNameKey] as? String
        userMention.indices = dictionary[indicesKey] as? NSObject
        return userMention
    }

    static func parseUrl(dictionary: [String: AnyObject]) -> Url {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let url = NSEntityDescription.insertNewObjectForEntityForName("Url", inManagedObjectContext: managedContext) as! Url

        url.url = dictionary[urlKey] as? String
        url.display_url = dictionary[displayUrlKey] as? String
        url.expanded_url = dictionary[expandedUrlKey] as? String
        url.indices = dictionary[indicesKey] as? NSObject
        return url
    }
    
    static func parseEntity(dictionary: [String: AnyObject]) -> Entity {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: managedContext) as! Entity

        if let mediaArray = dictionary[mediaKey] as? [AnyObject] {
            entity.media = parseArrayOfObjects(mediaArray, parseFunction: parseMedia)
        }
        if let symbolArray = dictionary[symbolsKey] as? [AnyObject] {
            entity.symbols = parseArrayOfObjects(symbolArray, parseFunction: parseSymbol)
        }
        if let urlArray = dictionary[urlsKey] as? [AnyObject] {
            entity.urls = parseArrayOfObjects(urlArray, parseFunction: parseUrl)
        }
        if let userMentionsArray = dictionary[userMentionsKey] as? [AnyObject] {
            entity.user_mentions = parseArrayOfObjects(userMentionsArray, parseFunction: parseUserMention)
        }
        if let hashtagsArray = dictionary[hashtagsKey] as? [AnyObject] {
            entity.hashtags = parseArrayOfObjects(hashtagsArray, parseFunction: parseMedia)
        }
        if let extendedEntitiesArray = dictionary[extendedEntitiesKey] as? [AnyObject] {
            entity.extended_entities = parseArrayOfObjects(extendedEntitiesArray, parseFunction: parseMedia)
        }
        return entity
    }
    
    static func parseEntities(array: [AnyObject]) -> NSSet {
        let entitiesArray = NSMutableSet()
        for entityDict in array{
            if let entityDict = entityDict as? [String: AnyObject] {
                let entity = parseEntity(entityDict)
                entitiesArray.addObject(entity)
            }
            
        }
        return entitiesArray
    }
    
    static func parseArrayOfObjects(array: [AnyObject], parseFunction: ([String: AnyObject]) -> AnyObject) -> NSSet {
        let objectsArray = NSMutableSet()
        for objectDict in array{
            if let objectDict = objectDict as? [String: AnyObject] {
                let object = parseFunction(objectDict)
                objectsArray.addObject(object)
            }
        }
        return objectsArray
    }
}
