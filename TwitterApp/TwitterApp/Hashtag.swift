//
//  Hashtag.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class Hashtag: NSManagedObject {
    static let entityName = "Hashtag"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForSymbol(managedContext: NSManagedObjectContext) -> Hashtag {
        let hashtag = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Hashtag
        return hashtag
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            self.setValue(value, forKey: keyName)
        }
    }
    
    static func getObjectForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> Hashtag {
        let hashtag = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Hashtag
        hashtag.dataFromDictionary(dictionary, managedContext: managedContext)
        return hashtag
    }
}
