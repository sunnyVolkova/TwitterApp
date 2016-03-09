//
//  SingleImageViewController.swift
//  TwitterApp
//
//  Created by RWuser on 04/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class SingleImageViewController: UIViewController {
    var imageUrlString: String?
    var tweetId: Int?
    var tweet: Tweet?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    @IBOutlet weak var retweetButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if let tweetId = tweetId {
            if let tweet = tweet {
                if tweet.retweeted == 1 {
                    NetworkService.sendUnRetweet(success: {
                        self.tweet!.retweeted = 0
                        self.initButtons(tweet)
                        }, failure: {_ in }, tweetId: tweetId)
                } else {
                    NetworkService.sendRetweet(success: {
                        self.tweet!.retweeted = 1
                        self.initButtons(tweet)
                        }, failure: {_ in}, tweetId: tweetId)
                }
            }
        }
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if let tweetId = tweetId {
            if let tweet = tweet {
                if tweet.favorited == 1 {
                    NetworkService.sendUnFavorite(success: {
                        self.tweet!.favorited = 0
                        self.initButtons(tweet)
                        }, failure: {_ in }, tweetId: tweetId)
                } else {
                    NetworkService.sendFavorite(success: {
                        self.tweet!.favorited = 1
                        self.initButtons(tweet)
                        }, failure: {_ in}, tweetId: tweetId)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrlString = imageUrlString {
            let urlMedia = NSURL(string: imageUrlString)
            imageView.sd_setImageWithURL(urlMedia)
        }
        if let tweetId = tweetId {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            if let tweet = Tweet.getTweetById(managedContext, tweetId: tweetId) {
                self.tweet = tweet
                initButtons(tweet)
            }
        }
    }
    
    func initButtons(tweet: Tweet){
        if tweet.favorited == 1 {
            favoriteButton.title = "UnFavorite"
        } else {
            favoriteButton.title = "Favorite"
        }
        
        if tweet.retweeted == 1 {
            retweetButton.title = "UnRetweet"
        } else {
            retweetButton.title = "Retweet"
        }
    }
}