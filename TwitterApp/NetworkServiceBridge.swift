//
//  NetworkServiceBridge.swift
//  TwitterApp
//
//  Created by Sunny on 21/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
@objc class NetworkServiceBridge: NSObject {
    static func sendRetweet(tweetId: Int, success: (Void) -> Void, failure: (NSError) -> Void){
        NetworkService.sendRetweet(success: {
            success()
            }, failure: {
                error in
                failure(error as NSError)
            }, tweetId: tweetId)
    }
    
    static func sendUnRetweet(tweetId: Int, success: (Void) -> Void, failure: (NSError) -> Void){
        NetworkService.sendUnRetweet(success: {
            success()
            }, failure: {
                error in
                failure(error as NSError)
            }, tweetId: tweetId)
    }
    
    static func sendFavorite(tweetId: Int, success: () -> Void, failure: (NSError) -> Void){
        NetworkService.sendFavorite(success: {
            success()
            }, failure: {
                error in
                failure(error as NSError)
            }, tweetId: tweetId)
    }
    
    static func sendUnFavorite(tweetId: Int, success: () -> Void, failure: (NSError) -> Void){
        NetworkService.sendUnFavorite(success: {
            success()
            }, failure: {
                error in
                failure(error as NSError)
            }, tweetId: tweetId)
    }
}