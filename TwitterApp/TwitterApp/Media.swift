//
//  Media.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class Media: NSManagedObject {
    static let entityName = "Media"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForSymbol(managedContext: NSManagedObjectContext) -> Media {
        let media = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Media
        return media
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            self.setValue(value, forKey: keyName)
        }
    }
    
    static func getObjectForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> Media {
        let media = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Media
        media.dataFromDictionary(dictionary, managedContext: managedContext)
        return media
    }
}
