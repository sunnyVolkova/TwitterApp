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
    @IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesContainer: UIView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var imageViews34Margin: NSLayoutConstraint!
    @IBOutlet weak var imageViews23Margin: NSLayoutConstraint!
    @IBOutlet weak var imageView2Width: NSLayoutConstraint!
    @IBOutlet weak var imageView3Height: NSLayoutConstraint!
    @IBOutlet weak var imageView4Height: NSLayoutConstraint!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    var tweet: Tweet?
    
    @IBAction func followButtonPressed(sender: AnyObject) {
    }

    func configureCell(tweet: Tweet) {
        self.tweet = tweet
        configureCellWithTweet(tweet)
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
            drawAdditionalImages(tweet.extended_entities!.media?.allObjects as! [Media])
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
    
    func drawAdditionalImages(images: [Media]) {
        let imageCount = images.count
            switch imageCount {
            case 1:
                imageView2Width.active = true
                imageView3Height.active = true
                imageView4Height.active = true
                imageViews23Margin.constant = 0
                imageViews34Margin.constant = 0
            case 2:
                imageView2Width.active = false
                imageView3Height.active = true
                imageView4Height.active = true
                imageViews23Margin.constant = 0
                imageViews34Margin.constant = 0
            case 3:
                imageView2Width.active = false
                imageView3Height.active = false
                imageView4Height.active = true
                imageViews23Margin.constant = defaultMargin
                imageViews34Margin.constant = 0
            case 4:
                imageView2Width.active = false
                imageView3Height.active = false
                imageView4Height.active = false
                imageViews23Margin.constant = defaultMargin
                imageViews34Margin.constant = defaultMargin
            default:
                imageView2Width.active = false
                imageView3Height.active = false
                imageView4Height.active = false
                imageViews23Margin.constant = defaultMargin
                imageViews34Margin.constant = defaultMargin
            }
        
        
        let imageViews = [imageView1, imageView2, imageView3, imageView4]
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        for i in 0..<imageCount {
            if let imageView = imageViews[i] {
                let tweetMedia =  images[i]
                let tweetImageURL = tweetMedia.media_url!
                let urlMedia = NSURL(string: tweetImageURL)
                imageView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
            }
        }
        updateConstraintsIfNeeded()
    }
}