//
//  Tweet.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
class Tweet{
    var id: Int
    var username: String
    var avatarURL: String
    var tweetText: String
    var date: NSDate
    var tweetImageURLs: [String]?
    
    init(id: Int, username: String, avatarURL: String, tweetText: String, date: NSDate, tweetImageURLs: [String]?){
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.tweetText = tweetText
        self.date = date
        self.tweetImageURLs = tweetImageURLs
    }
}
