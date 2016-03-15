//
//  TweetCell.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage
@objc protocol TweeCellButtonsClickDelegate {
    func favoriteButtonPressed(sender: UIButton!)
    
    func retweetButtonPressed(sender: UIButton!)
    
    func replyButtonPressed(sender: UIButton!)
    
    func imageTapped(imageUrl imageUrl: String, tweetId: Int)
}

class TweetCellView: UIView, ConfigureTweet{
    var mainView: UIView!
    var nibName = "TweetCellView"
    weak var tweetCellButtonsClickDelegate: TweeCellButtonsClickDelegate?
    var tweetId: Int?
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    //@IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
    //@IBOutlet weak var imagesContainer: UIView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var buttonRetweet: UIButton!
    @IBOutlet weak var stackViewForImages1: UIStackView!
    @IBOutlet weak var stackViewForImages2: UIStackView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    //@IBOutlet weak var aspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    //var aspectRatioConstraint: NSLayoutConstraint?
    
    @IBAction func onButtonReplyClick(sender: AnyObject) {
        if let tweetId = tweetId {
            buttonReply.tag = tweetId
        }
        tweetCellButtonsClickDelegate?.replyButtonPressed(buttonReply)
    }
    @IBAction func onButtonFavoriteClick(sender: AnyObject) {
        if let tweetId = tweetId {
            buttonFavorite.tag = tweetId
        }
        tweetCellButtonsClickDelegate?.favoriteButtonPressed(buttonFavorite)
    }
    @IBAction func onButtonRetweetClick(sender: AnyObject) {
        if let tweetId = tweetId {
            buttonRetweet.tag = tweetId
        }
        tweetCellButtonsClickDelegate?.retweetButtonPressed(buttonRetweet)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        loadNib()
    }
    
    convenience init?(coder aDecoder: NSCoder, nibName: String){
        self.init(coder: aDecoder)
        self.nibName = nibName
        loadNib()
    }
    
    func loadNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        mainView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        mainView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configureCell(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate) {
//        aspectRatioConstraint = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 3/5, constant: 0)
        
        tweetId = tweet.id as? Int
        tweetCellButtonsClickDelegate = tweetCellClickDelegate
        userName.text = tweet.user?.name
        tweetText.lineBreakMode = .ByWordWrapping
        tweetText.numberOfLines = 0
        tweetText.text = tweet.text
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        //date.sizeToFit()
        date.text = dateFormatter.stringFromDate(tweet.created_at!)
        initButtons(tweet)
        
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
        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0{
            stackView.hidden = false
            drawAdditionalImages(tweet)
        } else {
            stackView.hidden = true
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
        var imageViews = [image1, image3, image4, image2]
        let imageCount = tweet.extended_entities!.media!.count
        let images = tweet.extended_entities!.media!.allObjects
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
//        if (imageCount == 1) {
//            stackViewForImages2.hidden = true
//        } else {
//            stackViewForImages2.hidden = false
//        }
        for i in 0..<4 {
            if i < imageCount {
                //imageViews[i]?.image = nil
                let tweetMedia =  images[i] as! Media
                let tweetImageURL = tweetMedia.media_url!
                let urlMedia = NSURL(string: tweetImageURL)
                imageViews[i]?.hidden = false
                imageViews[i]?.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
            } else {
                imageViews[i]?.hidden = true
            }
        }
    }
    
//    func drawAdditionalImages(tweet: Tweet) {
//        let imageContainerWidth = imagesContainer.frame.width
//        let marginBetweenImages: CGFloat = 1
//        let imageCount = tweet.extended_entities!.media!.count
//        let images = tweet.extended_entities!.media!.allObjects
//        let divider: CGFloat = CGFloat(imageCount)
//        let startX = CGFloat(0)
//        let startY = CGFloat(0)
//        var smallSize = CGFloat(0)
//        if(imageCount > 1){
//            smallSize = CGFloat(imageContainerWidth - marginBetweenImages)/divider
//        }
//        let mainSize = (imageContainerWidth - marginBetweenImages) - smallSize
//        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            if (error != nil){
//                NSLog("error: \(error.description)")
//            }
//        }
//        
//        self.imageContainerHeightConstraint.constant = mainSize
//        
//        let mainView = UIImageView()
//        mainView.frame = CGRectMake(startX, startY, mainSize, mainSize)
//        mainView.contentMode = UIViewContentMode.ScaleAspectFill
//        self.imagesContainer.addSubview(mainView)
//        let tweetMedia =  images[0] as! Media
//        let tweetImageURL = tweetMedia.media_url!
//        let urlMedia = NSURL(string: tweetImageURL)
//        mainView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
//        addTap(mainView)
//        for i in 1..<imageCount {
//            let additionalView = UIImageView()
//            additionalView.contentMode = UIViewContentMode.ScaleAspectFill
//            additionalView.frame = CGRectMake(startX + mainSize + marginBetweenImages, startY + smallSize * CGFloat(i-1), smallSize, smallSize)
//            self.imagesContainer.addSubview(additionalView)
//            let tweetMedia =  images[i] as! Media
//            let tweetImageURL = tweetMedia.media_url!
//            let urlMedia = NSURL(string: tweetImageURL)
//            additionalView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
//            addTap(additionalView)
//        }
//    }
    
    func configureTweet(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate){
        configureCell(tweet, tweetCellClickDelegate: tweetCellClickDelegate)
    }
    
    func addTap(imageView: UIImageView) {
        let singleTap = UITapGestureRecognizer(target: self, action: "tapDetected:")
        singleTap.numberOfTapsRequired = 1
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
    
    func tapDetected(sender: AnyObject){
        if let imageView = sender.view as? UIImageView {
            let imageUrl = imageView.sd_imageURL().absoluteString
            tweetCellButtonsClickDelegate?.imageTapped(imageUrl: imageUrl, tweetId: tweetId!)
        }
    }
}

