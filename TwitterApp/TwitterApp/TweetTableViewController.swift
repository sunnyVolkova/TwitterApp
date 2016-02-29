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
    var twitterFetchedResultsController: NSFetchedResultsController!
    var conversationFetchedResultsController: NSFetchedResultsController!
    var tweetId: NSNumber = 0

    let tweetCellIdentifier = "MainTweetCell"
    let buttonsCellIdentifier = "Buttons Cell"
    let likeRetweetCellIdentifier = "Like Retweet Cell"
    let retweetedtweetCellIdentifier =  "Retweeted Cell"
    let repliedTweetCellIdentifier =  "ReplyCell"
    
    var isConversationPresent = true;
    let isRetweeted = 0
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        NSLog("sendButtonPressed")
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        if let tweet = twitterFetchedResultsController.fetchedObjects?[0] as? Tweet {
            if tweet.favorited == 1 {
                NetworkService.sendUnFavorite(success: {}, failure: {_ in }, tweetId: tweet.id as! Int)
            } else {
                NetworkService.sendFavorite(success: {}, failure: {_ in}, tweetId: tweet.id as! Int)
            }
        }
    }
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if let tweet = twitterFetchedResultsController.fetchedObjects?[0] as? Tweet {
            if tweet.retweeted == 1 {
                NetworkService.sendUnRetweet(success: {}, failure: {_ in }, tweetId: tweet.id as! Int)
            } else {
                NetworkService.sendRetweet(success: {}, failure: {_ in}, tweetId: tweet.id as! Int)
            }
        }
    }
    
    @IBAction func replyButtonPressed(sender: AnyObject) {
        NSLog("replyButtonPressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        initTweetFetchedResultsController()
        initConversationFetchedResultsController()
        //TODO: add request conversation        
    }
    
    func getManagedContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    func initTweetFetchedResultsController(){
        let fetchedRequest = NSFetchRequest(entityName: "Tweet")
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchedRequest.sortDescriptors = sortDescriptors
        let predicate = NSPredicate(format: "id == \(tweetId)")
        fetchedRequest.predicate = predicate
        twitterFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: getManagedContext(), sectionNameKeyPath: nil, cacheName: nil)
        twitterFetchedResultsController.delegate = self
        
        do {
            try twitterFetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Error: \(error.localizedDescription)")
        }
    }
    
    func initConversationFetchedResultsController(){
        let fetchedRequest = NSFetchRequest(entityName: "Tweet")
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchedRequest.sortDescriptors = sortDescriptors
        let predicate = NSPredicate(format: "in_reply_to_status_id == \(tweetId)")
        fetchedRequest.predicate = predicate
        conversationFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: getManagedContext(), sectionNameKeyPath: nil, cacheName: nil)
        conversationFetchedResultsController.delegate = self
        
        do {
            try conversationFetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Error: \(error.localizedDescription)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if(isConversationPresent){
//            return 2
//        } else {
//            return 1;
//        }
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3 + isRetweeted
        } else {
            if let count = conversationFetchedResultsController?.fetchedObjects?.count {
                return count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let tweet = twitterFetchedResultsController.fetchedObjects?[0] as? Tweet {
            if (indexPath.section == 0){
                switch indexPath.row {
                case 0 + self.isRetweeted:
                    NSLog("dequeueReusableCellWithIdentifier(tweetCellIdentifier...")
                    let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! ExtendedTweetCell
                    cell.configureCell(tweet)
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
                    
                    if tweet.retweeted == 1 {
                        cell.retweetButton.setTitle("UnRetweet", forState: UIControlState.Normal)
                    } else {
                        cell.retweetButton.setTitle("Retweet", forState: UIControlState.Normal)
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
            } else  if (indexPath.section == 1) {
                if let tweet = conversationFetchedResultsController.fetchedObjects?[indexPath.row] as? Tweet {
                    let cell = tableView.dequeueReusableCellWithIdentifier(repliedTweetCellIdentifier, forIndexPath: indexPath) as! BaseCell
                    cell.configureCell(tweet)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath) //TODO: show empty tweet
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath) //TODO: show empty tweet
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
        if (controller == twitterFetchedResultsController) {
            if type == .Update {
                NSLog("Update")
                //tableView.reloadData()
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
                if let tweet = controller.fetchedObjects?[0] as? Tweet {
                    NSLog("search replies")
                    NetworkService.searhRepliesOnTweet(tweet.id!, senderName: tweet.user!.screen_name!)
                }
            } else if type == .Insert {
                NSLog("Insert")
                if let tweet = controller.fetchedObjects?[0] as? Tweet {
                    NetworkService.searhRepliesOnTweet(tweet.id!, senderName: tweet.user!.screen_name!)
                }
            }
        } else if (controller == conversationFetchedResultsController) {
            NSLog("Update conversation")
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
