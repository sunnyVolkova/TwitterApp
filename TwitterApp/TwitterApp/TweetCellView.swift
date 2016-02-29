//
//  TweetCell.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage

class TweetCellView: UIView, ConfigureTweet{
    var mainView: UIView!
    var nibName = "TweetCellView"
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesContainer: UIView!   
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var buttonRetweet: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        NSLog("load nib1 \(nibName)")
        loadNib()
    }
    
    convenience init?(coder aDecoder: NSCoder, nibName: String){
        self.init(coder: aDecoder)
        self.nibName = nibName
        NSLog("load nib2 \(nibName)")
        loadNib()
    }
    
    func loadNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        mainView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        addSubview(mainView)
        let horizontalConstraintLeading = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraintLeading)
        let horizontalConstraintTrailing = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraintTrailing)
        let constraintTop = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        self.addConstraint(constraintTop)
        let constraintBottom = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(constraintBottom)
    }
    
    //func configureCell(tweet: Tweet, containerWidth: CGFloat) {
    func configureCell(tweet: Tweet) {
        
        userName.text = tweet.user?.name
        tweetText.lineBreakMode = .ByWordWrapping
        tweetText.numberOfLines = 0
        tweetText.text = tweet.text
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        //date.sizeToFit()
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
        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0{
            drawAdditionalImages(tweet)
        } else {
            imageContainerHeightConstraint.constant = 0
        }
        
        if tweet.replies != nil && tweet.replies!.count > 0{
            NSLog("replies!.count > 0 \((tweet.replies!.allObjects[0] as! Tweet).text)")
            bottomLineView.hidden = false
        } else {
            bottomLineView.hidden = true
        }
        
        if tweet.in_reply_to_status_id != nil && tweet.in_reply_to_status_id! != 0 {
            topLineView.hidden = false
        } else {
            topLineView.hidden = true
        }
    }
    
    func initButtons(tweet: Tweet){
        if tweet.favorited == 1 {
            buttonFavorite.setTitle("UnFavorite", forState: UIControlState.Normal)
        } else {
            buttonFavorite.setTitle("Favorite", forState: UIControlState.Normal)
        }
        
        if tweet.retweeted == 1 {
            buttonRetweet.setTitle("UnRetweet", forState: UIControlState.Normal)
        } else {
            buttonRetweet.setTitle("Retweet", forState: UIControlState.Normal)
        }
    }
    
    func drawAdditionalImages(tweet: Tweet) {
        let imageContainerWidth = imagesContainer.frame.width//getImageContainerWidth(containerWidth)
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
        
        self.imageContainerHeightConstraint.constant = mainSize
        
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
    
    func configureTweet(tweet: Tweet){
        configureCell(tweet)
    }
}

