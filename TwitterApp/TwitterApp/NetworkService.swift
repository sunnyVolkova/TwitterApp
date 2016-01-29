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
    
    static func getTimeline(success: ([Tweet]?) -> Void, failure: (ErrorType) -> Void) {
        if let oauthswift = oauthswift{
            oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: [:],
                success: {
                    data, response in
                    let tweets = TwitterParser.parseTwitData(data)
                    success(tweets)
                    //print(jsonDict)
                }, failure: { error in
                    print(error)
                    failure(error)
            })
        }
    
    }


}
