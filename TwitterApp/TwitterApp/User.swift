//
//  User.swift
//  TwitterApp
//
//  Created by RWuser on 08/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {
static let entityName = "User"
static let userIdKey = "id"
static let userCreatedAtKey = "created_at"
static let userStatusKey = "status"
   
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
// Insert code here to add functionality to your managed object subclass
    static func objectForUser(managedContext: NSManagedObjectContext, id: Int) -> User {
        var user: User
        var results: [User]? = nil
        let predicate = NSPredicate(format: "id = \(id)")
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        do {
            results = try managedContext.executeFetchRequest(request) as? [User]
        } catch let error as NSError {
            NSLog("Could not fetch \(error), \(error.userInfo)")
        }
        
        if results != nil && results?.count > 0 {
            user = results![0]
        } else {
            user = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! User
        }
        return user
    }
    
    func dataFromDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext){
        for(key, value) in dictionary{
            let keyName = key as String
            let keyValue = value as? String
            if (self.respondsToSelector(NSSelectorFromString(keyName))){
                switch key {
                case User.userCreatedAtKey:
                    if let date = Tweet.dateFromString(keyValue!){
                        self.setValue(date, forKey: keyName)
                    }
                case User.userStatusKey:
                    if let userStatusDictionary  = value as? [String: AnyObject] {
                        let tweet = Tweet.getTweetForDictionary(userStatusDictionary, managedContext: managedContext)
                        self.setValue(tweet, forKey: keyName)
                    }
                default:
                    self.setValue(keyValue, forKey: keyName)
                }
            }
        }
    }
    
    static func getUserForDictionary(dictionary: [String: AnyObject], managedContext: NSManagedObjectContext) -> User? {
        if let id = dictionary[User.userIdKey] as? Int{
            let user = User.objectForUser(managedContext, id: id)
            user.dataFromDictionary(dictionary, managedContext: managedContext)
            return user
        }
        return nil
    }
}
