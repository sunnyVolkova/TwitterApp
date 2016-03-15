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
    var tweet: Tweet?
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var buttonRetweet: UIButton!
    @IBOutlet weak var imagesContainer: UIView!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let tweet = tweet {
            if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0 {
                drawAdditionalImages(tweet)
            }
        }
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
        tweetId = tweet.id as? Int
        self.tweet = tweet
        tweetCellButtonsClickDelegate = tweetCellClickDelegate
        userName.text = tweet.user?.name
        tweetText.lineBreakMode = .ByWordWrapping
        tweetText.numberOfLines = 0
        tweetText.text = tweet.text
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
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
        
        for view in self.imagesContainer.subviews{
            view.removeFromSuperview()
        }
        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0{
            imagesContainer.hidden = false
            //drawAdditionalImages(tweet)
        } else {
            imagesContainer.hidden = true
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
        let marginBetweenImages: CGFloat = 8
        let imageContainerWidth = imagesContainer.window!.frame.width - avatarImage.frame.width - marginBetweenImages * 2
        let imageContainerHeight = imageContainerWidth * 0.6
        let imageCount = tweet.extended_entities!.media!.count
        let images = tweet.extended_entities!.media!.allObjects

        let smallWidth = CGFloat(imageContainerWidth - marginBetweenImages)/2
        let smallHeight = CGFloat(imageContainerHeight - marginBetweenImages)/2
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        for i in 0..<imageCount {
            var newImage: UIImageView?
            switch (imageCount, i) {
            case (1, 0):
                newImage = addImageToView(self.imagesContainer, w: imageContainerWidth, h: imageContainerHeight, x: 0, y: 0)
            case (2, 0):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: imageContainerHeight, x: 0, y: 0)
            case (2, 1):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: imageContainerHeight, x: smallWidth + marginBetweenImages, y: 0)
                break
            case (3, 0):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: imageContainerHeight, x: 0, y: 0)
                break
            case (3, 1):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: smallWidth + marginBetweenImages, y: 0)
                break
            case (3, 2):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: smallWidth + marginBetweenImages, y: smallHeight + marginBetweenImages)
                break
            case (4, 0):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: 0, y: 0)
                break
            case (4, 1):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: smallWidth + marginBetweenImages, y: 0)
                break
            case (4, 2):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: smallWidth + marginBetweenImages, y: smallHeight + marginBetweenImages)
                break
            case (4, 3):
                newImage = addImageToView(self.imagesContainer, w: smallWidth, h: smallHeight, x: 0, y: smallHeight + marginBetweenImages)
                break
            default:
                break
            }
            if let newImage = newImage {
                let tweetMedia =  images[i] as! Media
                let tweetImageURL = tweetMedia.media_url!
                let urlMedia = NSURL(string: tweetImageURL)
                newImage.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
            }
        }
    }
    
    func addImageToView(view: UIView, w: CGFloat, h: CGFloat, x: CGFloat, y: CGFloat) -> UIImageView {
        let additionalView = UIImageView()
        additionalView.contentMode = UIViewContentMode.ScaleAspectFill
        additionalView.frame = CGRectMake(x, y, w, h)
        additionalView.clipsToBounds = true
        addTap(additionalView)
        view.addSubview(additionalView)
        return additionalView
    }
    
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

