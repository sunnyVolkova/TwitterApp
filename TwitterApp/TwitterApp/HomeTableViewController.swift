//
//  HomeTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class HomeTableViewController: UITableViewController{
    var fetchedResultsController: NSFetchedResultsController!
    var maxId: Int = -1
    var sinceId: Int = -1
    let cellIdentifier = "Table View Base Cell"
    let extendedCellIdentifier = "Table View Extended Cell"
    let viewTweetSegueIdentifier = "ViewTweet"
    var selectedIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.redColor()
        self.refreshControl?.addTarget(self, action: Selector("getNewTweets"), forControlEvents: UIControlEvents.ValueChanged)
        
        var currentUserId = LoginService.getCurrentUserId()
        if (currentUserId == nil){
            currentUserId = -1
        }
        initFetchedResultsController(currentUserId: currentUserId!)
        
    }
    
    func initFetchedResultsController(currentUserId currentUserId: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchedRequest = NSFetchRequest(entityName: Tweet.entityName)
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        let sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format :"(in_reply_to_status_id = nil) || (in_reply_to_status_id == 0) && ((user.following = true)|| (user.id = \(currentUserId)))")
        fetchedRequest.sortDescriptors = sortDescriptors
        fetchedRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            NSLog("Error: \(error.localizedDescription)")
        }
    }

    func getNewTweets(){
        NetworkService.getNewTweets(success: {
            self.refreshControl?.endRefreshing()
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, sinceId: sinceId)
    }
    
    func getMoreTweets(){
        NetworkService.getMoreTweets(success: {
            self.refreshControl?.endRefreshing()
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, maxId: maxId)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NetworkService.getTimeline()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(fetchedResultsController.sections!.count > 0){
            return fetchedResultsController.sections!.count
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
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
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
        let tweet = fetchedResultsController.objectAtIndexPath(indexPath) as! Tweet
        if(tweet.replies != nil && tweet.replies!.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(extendedCellIdentifier, forIndexPath: indexPath) as? BaseCell
            cell!.configureCell(tweet, tweetCellClickDelegate: self)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? BaseCell
            cell!.configureCell(tweet, tweetCellClickDelegate: self)
            return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier(viewTweetSegueIdentifier, sender: self)
    }
    
    func configureCell(cell: TweetCellView, indexPath: NSIndexPath){
        let tweet = fetchedResultsController.objectAtIndexPath(indexPath) as! Tweet
        cell.configureCell(tweet, tweetCellClickDelegate: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == viewTweetSegueIdentifier {
            let tweetTableViewController = segue.destinationViewController as! TweetTableViewController
            if let indexPath = selectedIndexPath {
                let tweet = fetchedResultsController.fetchedObjects![indexPath.row] as? Tweet
                tweetTableViewController.tweetId = (tweet?.id)!
            }
        }
    }
}

extension HomeTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            if let cell = tableView.cellForRowAtIndexPath(indexPath!) as? BaseCell {
                let tweet = fetchedResultsController.objectAtIndexPath(indexPath!) as! Tweet
                cell.configureCell(tweet, tweetCellClickDelegate: self)
            }
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
        
        if let firstTweet = fetchedResultsController.fetchedObjects?[0] as? Tweet {
            sinceId = firstTweet.id as! Int
        }
        
        if let lastTweet = fetchedResultsController.fetchedObjects?[(fetchedResultsController.fetchedObjects?.count)! - 1] as? Tweet {
            maxId = lastTweet.id as! Int
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        //TODO: add correct scrolling
    }
}

extension HomeTableViewController: TweeCellButtonsClickDelegate {
    func favoriteButtonPressed(sender: UIButton!) {
        let tweetId = sender.tag
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if let tweet = Tweet.getTweetById(managedContext, tweetId: tweetId) {
            if tweet.favorited == 1 {
                NetworkService.sendUnFavorite(success: {}, failure: {_ in }, tweetId: tweetId)
            } else {
                NetworkService.sendFavorite(success: {}, failure: {_ in}, tweetId: tweetId)
            }
        }
    }
    
    func retweetButtonPressed(sender: UIButton!) {
        let tweetId = sender.tag
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if let tweet = Tweet.getTweetById(managedContext, tweetId: tweetId) {
            if tweet.retweeted == 1 {
                NetworkService.sendUnRetweet(success: {}, failure: {_ in }, tweetId: tweetId)
            } else {
                NetworkService.sendRetweet(success: {}, failure: {_ in}, tweetId: tweetId)
            }
        }
    }
    
    func replyButtonPressed(sender: UIButton!) {
        NSLog("replyButtonPressed")
        //let tweetId = sender.tag
        //TODO: reply tweetId
    }
}

