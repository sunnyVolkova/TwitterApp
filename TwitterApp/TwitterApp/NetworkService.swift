//
//  NetworkService.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import OAuthSwift
import CoreData

class NetworkService {
    static var oauthswift: OAuth1Swift?
    static let numberOfTweetsOnPage = 20
    
    static func getTimeline() {
         NSLog("getTimeline")
        let parameters: Dictionary = [
            "count"           : "\(numberOfTweetsOnPage)",
        ]
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters,
                success: {
                    data, response in
                   DataService.parseAndStoreTwitData(data)
                }, failure: { error in
                    print(error)
            })
        }
    
    }

    
    static func getNewTweets(success success: () -> Void, failure: (ErrorType) -> Void, sinceId: Int) {
         NSLog("getNewTweets")
        var parameters:Dictionary = [
            "count"           : "\(numberOfTweetsOnPage)",
        ]
        if(sinceId > 0){
            parameters["since_id"] = "\(sinceId)"
        }
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters,
                success: {
                    data, response in
                    DataService.parseAndStoreTwitData(data)
                    success()
                }, failure: { error in
                    print(error)
                    failure(error)
            })        }
        
    }
    
    static func getMoreTweets(success success: () -> Void, failure: (ErrorType) -> Void, maxId: Int) {
        NSLog("getMoreTweets")
        var parameters:Dictionary = [
            "count"           : "\(numberOfTweetsOnPage)",
        ]
        if(maxId > 0){
            parameters["max_id"] = "\(maxId - 1)"
        }
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters,
                success: {
                    data, response in
                    DataService.parseAndStoreTwitData(data)
                    success()
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    }
    
    static func sendFavorite(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
        NSLog("sendFavorite")
        let parameters:Dictionary = [
            "id"           : "\(tweetId)",
        ]
        if let oauthswift = oauthswift{
            oauthswift.client.post("https://api.twitter.com/1.1/favorites/create.json", parameters: parameters,
                success: {
                    data, response in
                    DataService.parseAndStoreSingleTwitData(data)
                    success()
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    }
    
    static func sendUnFavorite(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
        NSLog("sendUnFavorite")
        let parameters:Dictionary = [
            "id"           : "\(tweetId)",
        ]
        if let oauthswift = oauthswift{
            oauthswift.client.post("https://api.twitter.com/1.1/favorites/destroy.json", parameters: parameters,
                success: {
                    data, response in
                    DataService.parseAndStoreSingleTwitData(data)
                    success()
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    }
}
