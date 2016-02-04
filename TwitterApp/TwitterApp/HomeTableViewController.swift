//
//  HomeTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewController: UITableViewController{
    var tweets: [Tweet] = []
    var wasDragged = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.redColor()
        self.refreshControl?.addTarget(self, action: Selector("getNewTweets"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func getNewTweets(){
        NetworkService.getNewTweets(success: {tweets in
            self.refreshControl?.endRefreshing()
            var indexPaths: [NSIndexPath] = []
            var count = 0
            for tweet in tweets! {
                self.tweets.insert(tweet, atIndex: count)
                indexPaths.append(NSIndexPath(forRow: count, inSection: 0))
                count++
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, sinceId: NetworkService.sinceId)
    }
    
    func getMoreTweets(){
        NetworkService.getMoreTweets(success: {tweets in
            self.refreshControl?.endRefreshing()
            var indexPaths: [NSIndexPath] = []
            var count = 0
            let prevRowCount = self.tweets.count
            for tweet in tweets! {
                self.tweets.append(tweet)
                indexPaths.append(NSIndexPath(forRow: prevRowCount + count - 1, inSection: 0))
                count++
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(indexPaths.last!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, maxId: NetworkService.maxId)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NetworkService.getTimeline(success: { tweets in
            self.tweets = tweets!
            self.tableView.reloadData()
            NSLog("tweets number : \(self.tweets.count)")
            }, failure: { error in
                NSLog("Error getting tweets")
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: false)    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tweets.count > 0){
            return 1
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            messageLabel.text = "No data is currently available."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        }
        
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            getMoreTweets()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = self.tweets[indexPath.row]
        if tweet.tweetImageURLs != nil && tweet.tweetImageURLs?.count > 0{
            let cellIdentifier = "TweetCellWithImage"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCellWithImage
            fillCellWithImageTweet(cell: cell, tweet: tweet)
            return cell
        } else {
            let cellIdentifier = "TweetCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCell
            fillCellWithTweet(cell: cell, tweet: tweet)
            return cell
        }
    }
    
    func fillCellWithTweet(cell cell: TweetCell, tweet: Tweet){
        cell.userName.text = tweet.username
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet.tweetText
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        cell.date.sizeToFit()
        cell.date.text = dateFormatter.stringFromDate(tweet.date)
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error loading image: \(error.description)")
            }
        }
        
        let url = NSURL(string: tweet.avatarURL)
        cell.avatarImage.sd_cancelCurrentImageLoad()
        cell.avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
    }
    
    func fillCellWithImageTweet(cell cell: TweetCellWithImage, tweet: Tweet){
        
        cell.userName.text = tweet.username
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet.tweetText
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        cell.date.sizeToFit()
        cell.date.text = dateFormatter.stringFromDate(tweet.date)
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error loading image: \(error.description)")
            }
        }
        
        let url = NSURL(string: tweet.avatarURL)
        cell.avatarImage.sd_cancelCurrentImageLoad()
        cell.avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
        
        if tweet.tweetImageURLs != nil && tweet.tweetImageURLs?.count > 0{
            if(tweet.tweetImageURLs?.count > 1){
                for i in 0..<tweet.tweetImageURLs!.count{
                    let urlMedia = NSURL(string: tweet.tweetImageURLs![i])
                    let imageView: UIImageView
                    switch(i){
                    case 0:
                        imageView = cell.mainImage
                    case 1:
                        imageView = cell.additionalImage1
                    case 2:
                        imageView = cell.additionalImage2
                    case 3:
                        imageView = cell.additionaImage3
                    default:
                        imageView = UIImageView()
                    }
                    imageView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: {
                        (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    })
                }
            }
        }
    }
    
}

