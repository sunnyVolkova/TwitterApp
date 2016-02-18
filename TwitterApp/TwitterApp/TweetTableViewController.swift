//
//  TweetTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 16/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class TweetTableViewController: UITableViewController {
    @IBOutlet weak var likeRetweetLabel: UIView!
    var fetchedResultsController: NSFetchedResultsController!
    var tweetId: NSNumber = 0

    let retweetedtweetCellIdentifier =  "Retweeted Cell"
    let tweetCellIdentifier = "MainTweetCell"
    let likeRetweetCellIdentifier = "Like Retweet Cell"
    let buttonsCellIdentifier = "Buttons Cell"
    
    var isConversationPresent = false;
    let isRetweeted = 0
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        NSLog("sendButtonPressed")
    }
    @IBAction func likeButtonPressed(sender: AnyObject) {
        if let tweet = fetchedResultsController.fetchedObjects?[0] as? Tweet {
            if tweet.favorited == 1 {
                NetworkService.sendUnFavorite(success: {}, failure: {_ in }, tweetId: tweet.id as! Int)
            } else {
                NetworkService.sendFavorite(success: {}, failure: {_ in}, tweetId: tweet.id as! Int)
            }
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchedRequest = NSFetchRequest(entityName: "Tweet")
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchedRequest.sortDescriptors = sortDescriptors
        let predicate = NSPredicate(format: "id == \(tweetId)")
        fetchedRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Error: \(error.localizedDescription)")
        }
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
        if let tweet = fetchedResultsController.fetchedObjects?[0] as? Tweet {
            if(indexPath.section == 0){
                switch indexPath.row {
                case 0 + self.isRetweeted:
                    let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath)  as! ExtendedTweetCell
                    let margin: CGFloat = 8
                    let containerWidth = self.tableView.frame.size.width - margin*2
                    cell.configureCell(tweet, containerWidth: containerWidth)
                    return cell
                    
                case 1 + isRetweeted:
                    let cell = tableView.dequeueReusableCellWithIdentifier(likeRetweetCellIdentifier, forIndexPath: indexPath) as! SimpleTextCell
                    let retweetCountString = "\(((tweet.retweet_count) != nil) ? (tweet.retweet_count)! : 0)"
                    let favoriteCountString = "\(((tweet.favorite_count) != nil) ? (tweet.favorite_count)! : 0)"
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
                    if tweet.favorited == 1 {
                        cell.likeButton.setTitle("UnFavorite", forState: UIControlState.Normal)
                    } else {
                        cell.likeButton.setTitle("Favorite", forState: UIControlState.Normal)
                    }
                    return cell
                    
                default:
                    let cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath)
                    if tweet.retweeted == 1 {
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
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath) //TODO: show empty tweet
            return cell
        }
    }
}

extension TweetTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Update {
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
