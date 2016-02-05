//
//  TwitterParser.swift
//  TwitterApp
//
//  Created by RWuser on 29/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
class TwitterParser{
    static let tweetIdKey = "id"
    static let tweetTextKey = "text"
    static let tweetDateKey = "created_at"
    static let tweetUserKey = "user"
    static let tweetEntitiesKey = "extended_entities"
    
    //user
    static let userNameKey = "name"
    static let userImageUrlKey = "profile_image_url"
    
    //entities
    static let mediaKey = "media"
    
    //media
    static let mediaUrlKey = "media_url"
    static let typeKey = "type"
    
    //date format
    static let dateFormat = "EEE' 'MMM' 'dd' 'HH':'mm':'ss' 'Z' 'yyyy"
    
    static func parseTwit(dictionary: [String: AnyObject]) -> Tweet{
        let id = dictionary[tweetIdKey] as! Int
        let text = dictionary[tweetTextKey] as! String
        let dateString = dictionary[tweetDateKey] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.dateFromString(dateString)
        
        let user = dictionary[tweetUserKey] as! [String: AnyObject]
        let userName = user[userNameKey] as! String
        let userAvatar = user[userImageUrlKey] as! String
        
        var mediaURLs: [String] = []
        
        if let entities = dictionary[tweetEntitiesKey] as? [String: AnyObject]{
            if let media = entities[mediaKey] as? [AnyObject] {
                NSLog("media.count =  \(media.count)")
                for mediaItem in media{
                    if let mediaDict = mediaItem as? [String: AnyObject]{
                        if let mediaURL  = mediaDict[mediaUrlKey] as? String {
                            mediaURLs.append(mediaURL)
                        }
                    }
                }
            }
        }
        let tweet = Tweet(id: id, username: userName, avatarURL: userAvatar, tweetText: text, date: date!, tweetImageURLs: mediaURLs)
        return tweet
    }
    
    static func parseTwitArray(array: [AnyObject]) -> [Tweet]{
        var tweetArray: [Tweet] = []
        for tweetDict in array{
            if let tweetDict = tweetDict as? [String: AnyObject]{
                let tweet = parseTwit(tweetDict)
                tweetArray.append(tweet)
            }
            
        }
        return tweetArray
    }
    
    static func parseTwitData(data: NSData) -> [Tweet]{
        let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
        return parseTwitArray(jsonDict as! [Tweet])
    }
    
    
}