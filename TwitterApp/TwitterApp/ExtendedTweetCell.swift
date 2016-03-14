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
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesContainer: UIView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var imageContainerAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var followButton: UIButton!
    
    var tweet: Tweet?
    
    @IBAction func followButtonPressed(sender: AnyObject) {
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tweet = tweet {
            if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0 {
                drawAdditionalImages(tweet)
            }
        }
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
        date.text = dateFormatter.stringFromDate(tweet.created_at!)
        
        
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
        
        
        for view in self.imagesContainer.subviews{
            view.removeFromSuperview()
        }
        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0 {
            if let imageContainerAspectRatioConstraint = imageContainerAspectRatioConstraint {
                imageContainerAspectRatioConstraint.active = true
            }
            //drawAdditionalImages(tweet)
            NSLog("self.frame.width1 \(self.frame.width)")

            //imageContainerHeightConstraint.constant = self.frame.width
        } else {
            if let imageContainerAspectRatioConstraint = imageContainerAspectRatioConstraint {
                imageContainerAspectRatioConstraint.active = false
            }
            imageContainerHeightConstraint.constant = 0
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
    
    func drawAdditionalImages(tweet: Tweet) {
        let imageContainerWidth = self.frame.width
        NSLog("self.frame.width2 \(self.frame.width)")
        let marginBetweenImages: CGFloat = 1
        let imageCount = tweet.extended_entities!.media!.count
        let images = tweet.extended_entities!.media!.allObjects
        let divider: CGFloat = CGFloat(imageCount)
        let startX = CGFloat(0)
        let startY = CGFloat(0)
        var smallSize = CGFloat(0)
        if(imageCount > 1){
            smallSize = CGFloat(imageContainerWidth - marginBetweenImages)/divider
        }
        let mainSize = (imageContainerWidth - marginBetweenImages) - smallSize
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        
        //self.imageContainerHeightConstraint.constant = mainSize
        
        let mainView = UIImageView()
        mainView.frame = CGRectMake(startX, startY, mainSize, mainSize)
        mainView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imagesContainer.addSubview(mainView)
        let tweetMedia =  images[0] as! Media
        let tweetImageURL = tweetMedia.media_url!
        let urlMedia = NSURL(string: tweetImageURL)
        mainView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
        
        for i in 1..<imageCount {
            let additionalView = UIImageView()
            additionalView.contentMode = UIViewContentMode.ScaleAspectFill
            additionalView.frame = CGRectMake(startX + mainSize + marginBetweenImages, startY + smallSize * CGFloat(i-1), smallSize, smallSize)
            self.imagesContainer.addSubview(additionalView)
            let tweetMedia =  images[i] as! Media
            let tweetImageURL = tweetMedia.media_url!
            let urlMedia = NSURL(string: tweetImageURL)
            additionalView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
        }
    }
}