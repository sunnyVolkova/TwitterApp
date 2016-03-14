//
//  UserMention.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class UserMention: NSManagedObject {
    static let entityName = "UserMention"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForMention(managedContext: NSManagedObjectContext) -> UserMention {
        let symbol = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! UserMention
        return symbol
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            self.setValue(value, forKey: keyName)
        }
    }
    
    static func getObjectForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> UserMention {
        let object = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! UserMention
        object.dataFromDictionary(dictionary, managedContext: managedContext)
        return object
    }
}
