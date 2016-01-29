//
//  HomeTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class HomeTableViewController: UITableViewController{
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("HomeTableViewController viewDidAppear")
        NetworkService.getTimeline({ tweets in
            self.tweets = tweets!
            self.tableView.reloadData()
            NSLog("tweets number : \(self.tweets.count)")
            }, failure: { error in
                NSLog("Error getting tweets")
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TweetCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCell
        let tweet = self.tweets[indexPath.row]
        cell.userName.text = tweet.username
        
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet.tweetText
        NSLog("Add cell \(tweet.tweetText)")
        return cell
    }
    
}

