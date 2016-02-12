//
//  Url.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class Url: NSManagedObject {
    static let entityName = "Url"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForSymbol(managedContext: NSManagedObjectContext) -> Url {
        let url = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Url
        return url
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            self.setValue(value, forKey: keyName)
        }
    }
    
    static func getObjectForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> Url {
        let url = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Url
        url.dataFromDictionary(dictionary, managedContext: managedContext)
        return url
    }
}
