//
//  ExtendedTweetCell.swift
//  TwitterApp
//
//  Created by RWuser on 16/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class ExtendedTweetCell: TweetCell{
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBAction func followButtonPressed(sender: AnyObject) {
    }
    
    override func configureCell(tweet: Tweet, containerWidth: CGFloat) {
        super.configureCell(tweet, containerWidth: containerWidth)
        if let screenNameText = tweet.user?.screen_name {
            screenName.text = "@" + screenNameText
        }        
        if tweet.user?.following == 1 || tweet.user?.follow_request_sent == 1 {
            followButton.hidden = false
        } else {
            followButton.hidden = true
        }
    }
    
    
    override func getImageContainerWidth(containerWidth: CGFloat) -> CGFloat{
        return containerWidth
    }
}