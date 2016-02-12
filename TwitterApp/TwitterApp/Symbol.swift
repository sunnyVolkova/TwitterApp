//
//  Symbol.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class Symbol: NSManagedObject {
    static let entityName = "Symbol"
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    static func objectForSymbol(managedContext: NSManagedObjectContext) -> Symbol {
        let symbol = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Symbol
        return symbol
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            self.setValue(value, forKey: keyName)
        }
    }
    
    static func getObjectForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> Symbol {
        let symbol = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! Symbol
        symbol.dataFromDictionary(dictionary, managedContext: managedContext)
        return symbol
    }
}
