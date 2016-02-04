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
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
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
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
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
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        //NSInteger result = maximumOffset - currentOffset;
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            getMoreTweets()
        }
        NSLog("End dragging")
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TweetCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCell
        let tweet = self.tweets[indexPath.row]
        cell.userName.text = tweet.username
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet.tweetText
       
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
            if(cacheType == .None){
                self.tableView.reloadData()
            }
            //self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
            //tableView.reloadRowsAtIndexPaths([indexPath, indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        
        let block2: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
            if(cacheType == .None){
                self.tableView.reloadData()
            }
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        
        let url = NSURL(string: tweet.avatarURL)
        cell.avatarImage.sd_cancelCurrentImageLoad()
        cell.avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
        for view in cell.mediaContentView.arrangedSubviews{
            view.removeFromSuperview()
        }
        NSLog("tweet.tweetImageURLs?.count \(tweet.tweetImageURLs?.count)")
        if tweet.tweetImageURLs != nil && tweet.tweetImageURLs?.count > 0 {
            for tweetImageURL in tweet.tweetImageURLs!{
                if !tweetImageURL.isEmpty {
                    NSLog("load image \(tweetImageURL)")
                    let urlMedia = NSURL(string: tweetImageURL)
                    let imageView = UIImageView()
                    imageView.clipsToBounds = true
                    cell.mediaContentView.addArrangedSubview(imageView)
                    imageView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block2)
                }
            }
        }
        return cell
    }
    
}

