//
//  NetworkService.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import OAuthSwift

class NetworkService {
    static var oauthswift: OAuth1Swift?
    static var maxId: Int = -1
    static var sinceId: Int = -1
    static let numberOfTweetsOnPage = 20
    
    static func getTimeline(success success: ([Tweet]?) -> Void, failure: (ErrorType) -> Void) {
         NSLog("getTimeline")
        let parameters:Dictionary = [
            "count"           : "\(numberOfTweetsOnPage)",
        ]
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters,
                success: {
                    data, response in
                    let tweets = Parser.parseTwitData(data)
                    if(tweets.count > 0){
                        NetworkService.sinceId = tweets[0].id as! Int
                        NSLog("sinceId: \(NetworkService.sinceId)")
                        NetworkService.maxId = tweets[tweets.count - 1].id as! Int
                        NSLog("maxId: \(NetworkService.maxId)")
                    }
                    success(tweets)
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    
    }
    
    static func getNewTweets(success success: ([Tweet]?) -> Void, failure: (ErrorType) -> Void, sinceId: Int) {
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
                    let tweets = Parser.parseTwitData(data)
                    if(tweets.count > 0){
                        NetworkService.sinceId = tweets[0].id as! Int
                        NSLog("sinceId: \(NetworkService.sinceId)")
                    }
                    success(tweets)
                }, failure: { error in
                    print(error)
                    failure(error)
            })        }
        
    }
    
    static func getMoreTweets(success success: ([Tweet]?) -> Void, failure: (ErrorType) -> Void, maxId: Int) {
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
                    let tweets = Parser.parseTwitData(data)
                    if(tweets.count > 0){
                        NetworkService.maxId = tweets[tweets.count - 1].id as! Int
                        NSLog("maxId: \(NetworkService.maxId)")
                    }
                    success(tweets)
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    }


}
