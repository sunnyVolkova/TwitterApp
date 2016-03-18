//
//  ExtendedTweetCell.swift
//  TwitterApp
//
//  Created by RWuser on 16/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage
class ExtendedTweetCell: UITableViewCell {
    let defaultMargin: CGFloat = 8
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imagesContainer: ImagesContainerView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    var tweet: Tweet?
    
    @IBAction func followButtonPressed(sender: AnyObject) {
    }

    func configureCell(tweet: Tweet) {
        self.tweet = tweet
        configureCellWithTweet(tweet)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tweet = tweet {
            if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0 {
                imagesContainer.drawAdditionalImages(tweet.extended_entities!.media!.allObjects as! [Media])
            }
        }
    }
    
    func configureCellWithTweet(tweet: Tweet) {
        userName.text = tweet.user?.name
        tweetText.lineBreakMode = .ByWordWrapping
        tweetText.numberOfLines = 0
        tweetText.text = tweet.text
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        if let createdAt = tweet.created_at {
            date.text = dateFormatter.stringFromDate(createdAt)
        }
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        
        avatarImage.sd_cancelCurrentImageLoad()
        if let urlString = tweet.user?.profile_image_url {
            let url = NSURL(string: urlString)
            avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
        } else {
            avatarImage.image = UIImage(named: "PlaceholderImage")
        }

        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0 {
            imagesContainer.hidden = false
        } else {
            imagesContainer.hidden = true
        }
        
        if let screenNameText = tweet.user?.screen_name {
            screenName.text = "@" + screenNameText
        }        
        if tweet.user?.following == 1 || tweet.user?.follow_request_sent == 1 {
            followButton.hidden = false
        } else {
            followButton.hidden = true
        }
    }
}