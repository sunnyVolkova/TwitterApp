//
//  TweetTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 16/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage

class TweetTableViewController: UITableViewController {
    @IBOutlet weak var likeRetweetLabel: UIView!
    var isConversationPresent = false;
    var tweet: Tweet? = nil
    let retweetedtweetCellIdentifier =  "Retweeted Cell"
    let tweetCellIdentifier = "MainTweetCell"
    let likeRetweetCellIdentifier = "Like Retweet Cell"
    let buttonsCellIdentifier = "Buttons Cell"
    let isRetweeted = 0
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        NSLog("sendButtonPressed")
    }
    @IBAction func likeButtonPressed(sender: AnyObject) {
        if tweet?.favorited == 1 {
            NetworkService.sendUnFavorite(success: {
                self.tweet?.favorited = 0
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                }, failure: {_ in }, tweetId: tweet?.id as! Int)
        } else {
            NetworkService.sendFavorite(success: {
                self.tweet?.favorited = 1
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                }, failure: {_ in}, tweetId: tweet?.id as! Int)
        }
        NSLog("likeButtonPressed")
    }
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        NSLog("retweetButtonPressed")
    }
    @IBAction func replyButtonPressed(sender: AnyObject) {
        NSLog("replyButtonPressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(isConversationPresent){
            return 2
        } else {
            return 1;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3 + isRetweeted
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            switch indexPath.row {
            case 0 + self.isRetweeted:
                let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath)  as! ExtendedTweetCell
                let margin: CGFloat = 8
                let containerWidth = self.tableView.frame.size.width - margin*2
                cell.configureCell(tweet!, containerWidth: containerWidth)
                return cell
                
            case 1 + isRetweeted:
                let cell = tableView.dequeueReusableCellWithIdentifier(likeRetweetCellIdentifier, forIndexPath: indexPath) as! SimpleTextCell
                let retweetCountString = "\(((tweet?.retweet_count) != nil) ? (tweet!.retweet_count)! : 0)"
                let favoriteCountString = "\(((tweet?.favorite_count) != nil) ? (tweet!.favorite_count)! : 0)"
                let stringToDisplay = "\(retweetCountString) retweeted, \(favoriteCountString) favorited"
                
                let range1 = (stringToDisplay as NSString).rangeOfString(retweetCountString)
                let subRange = NSRange(location: range1.length, length: stringToDisplay.characters.count - range1.length)
                let range2 = (stringToDisplay as NSString).rangeOfString(favoriteCountString, options: .LiteralSearch, range: subRange as NSRange)
                let attributedStringToDisplay = NSMutableAttributedString(string: stringToDisplay)
                attributedStringToDisplay.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize((cell.simpleTextLabel?.font.pointSize)!), range: range1)
                attributedStringToDisplay.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize((cell.simpleTextLabel?.font.pointSize)!), range: range2)
                cell.simpleTextLabel?.attributedText = attributedStringToDisplay
                
                return cell
                
            case 2 + isRetweeted:
                let cell = tableView.dequeueReusableCellWithIdentifier(buttonsCellIdentifier, forIndexPath: indexPath) as! TweetButtonsCell
                if tweet?.favorited == 1 {
                    cell.likeButton.setTitle("UnFavorite", forState: UIControlState.Normal)
                } else {
                    cell.likeButton.setTitle("Favorite", forState: UIControlState.Normal)
                }
                return cell
                
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath)
                if tweet!.retweeted == 1 {
                    cell.textLabel?.text = "Retweeted from ...."
                } else {
                    cell.textLabel?.text = ""
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! ExtendedTweetCell
            return cell
        }
    }
}
