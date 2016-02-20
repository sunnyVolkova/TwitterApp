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
    static let numberOfRepliesToFind = 100
    
    static func getTimeline() {
        let parameters: Dictionary = [
            "count"           : "\(numberOfTweetsOnPage)",
        ]
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: parameters,
                success: {
                    data, response in
                    DataService.parseAndStoreTwitData(data)
                }, failure: { error in
                    NSLog("error \(error) \(error.userInfo)")
            })
        }
        
    }
    
    
    static func getNewTweets(success success: () -> Void, failure: (ErrorType) -> Void, sinceId: Int) {
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
                    NSLog("error \(error) \(error.userInfo)")
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
                    NSLog("error \(error) \(error.userInfo)")
                    failure(error)
            })
        }
    }
    
    static func sendFavorite(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
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
                    NSLog("error \(error) \(error.userInfo)")
                    failure(error)
            })
        }
    }
    
    static func sendUnFavorite(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
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
                    NSLog("error \(error) \(error.userInfo)")
                    failure(error)
            })
        }
    }
    
    static func sendRetweet(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
        if let oauthswift = oauthswift{
            oauthswift.client.post("https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json",
                success: {
                    data, response in
                    DataService.parseAndStoreSingleTwitData(data)
                    success()
                }, failure: { error in
                    NSLog("error \(error) \(error.userInfo)")
                    failure(error)
            })
        }
    }
    
    static func sendUnRetweet(success success: () -> Void, failure: (ErrorType) -> Void, tweetId: Int){
        if let oauthswift = oauthswift{
            oauthswift.client.post("https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json",
                success: {
                    data, response in
                    reloadSungleTweet(tweetId)
                    DataService.parseAndStoreSingleTwitData(data)
                    DataService.removeTweetsWithIdsFromCoreData(DataService.getMyRetweetIdsForTweet(tweetId: tweetId)!)
                    success()
                }, failure: { error in
                    NSLog("sendUnRetweet failure \(error) \(error.userInfo)")
                    failure(error )
            })
        }
    }
    
    static func reloadSungleTweet(tweetId: Int){
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/show/\(tweetId).json",
                success: {
                    data, response in
                    DataService.parseAndStoreSingleTwitData(data)
                }, failure: { error in
                    NSLog("reload tweet failure \(error) \(error.userInfo)")
            })
        }
    }
    
    static func searhRepliesOnTweet(tweetId: NSNumber, senderName: NSString) {
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/search/tweets.json?q=\(senderName)&since_id=\(tweetId)&count=\(numberOfRepliesToFind)",
                success: {
                    data, response in
                    NSLog("search success")
                    DataService.parseAndStoreFoundStatuses(data)
                }, failure: { error in
                    NSLog("reload tweet failure \(error) \(error.userInfo)")
            })
        }
    }
}
