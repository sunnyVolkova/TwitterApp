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
    @IBOutlet weak var imagesContainer: ImagesContainerView!
    
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
                imagesContainer.drawAdditionalImages(tweet.extended_entities!.media!.allObjects as! [Media])
                imagesContainer.addTapToImages{imageUrl in
                        self.tweetCellButtonsClickDelegate?.imageTapped(imageUrl: imageUrl, tweetId: self.tweetId!)
                }
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
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        if let createdAt = tweet.created_at {
            date.text = dateFormatter.stringFromDate(createdAt)
        }
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
            imagesContainer.hidden = false
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
    
    func configureTweet(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate){
        configureCell(tweet, tweetCellClickDelegate: tweetCellClickDelegate)
    }
}

