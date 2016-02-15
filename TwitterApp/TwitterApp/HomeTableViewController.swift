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
    var tweets: [Tweet] = []
    var observer: AnyObject!
    
    var maxId: Int = -1
    var sinceId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()
        self.refreshControl?.tintColor = UIColor.redColor()
        self.refreshControl?.addTarget(self, action: Selector("getNewTweets"), forControlEvents: UIControlEvents.ValueChanged)
        addObserver()
        
    }
    
    func addObserver(){
        observer = NSNotificationCenter.defaultCenter().addObserverForName(DataService.timelineGotNotificationName, object: nil, queue: NSOperationQueue.mainQueue()){_ in
            self.reloadTimelineFromCoreData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    func getNewTweets(){
        NetworkService.getNewTweets(success: {
            self.refreshControl?.endRefreshing()
//            var indexPaths: [NSIndexPath] = []
//            var count = 0
//            for tweet in tweets! {
//                self.tweets.insert(tweet, atIndex: count)
//                indexPaths.append(NSIndexPath(forRow: count, inSection: 0))
//                count++
//            }
//            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, sinceId: sinceId)
    }
    
    func getMoreTweets(){
        NetworkService.getMoreTweets(success: {
            self.refreshControl?.endRefreshing()
//            var indexPaths: [NSIndexPath] = []
//            var count = 0
//            let prevRowCount = self.tweets.count
//            for tweet in tweets! {
//                self.tweets.append(tweet)
//                indexPaths.append(NSIndexPath(forRow: prevRowCount + count - 1, inSection: 0))
//                count++
//            }
//            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//            self.tableView.scrollToRowAtIndexPath(indexPaths.last!, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }, failure: { error in
                self.refreshControl?.endRefreshing()
                NSLog("Error getting tweets")
            }, maxId: maxId)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadTimelineFromCoreData()
        NetworkService.getTimeline()
    }
    
    func reloadTimelineFromCoreData(){
        NSLog("Reload timeline")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: Tweet.entityName)
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        do{
            let results = try managedContext.executeFetchRequest(request) as! [Tweet]
            NSLog("results count = \(results.count)")
            self.tweets = results
            sinceId = tweets[0].id as! Int
            maxId = tweets[tweets.count - 1].id as! Int
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.setNavigationBarHidden(false, animated: false)
    }
    
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
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            getMoreTweets()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TweetCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCell
        let tweet = self.tweets[indexPath.row]
        cell.userName.text = tweet.user?.name
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet.text
       
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        cell.date.sizeToFit()
        cell.date.text = dateFormatter.stringFromDate(tweet.created_at!)

        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        
        let url = NSURL(string: (tweet.user?.profile_image_url)!)
        cell.avatarImage.sd_cancelCurrentImageLoad()
        cell.avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
        for view in cell.imagesContainer.subviews{
            view.removeFromSuperview()
        }
        if tweet.extended_entities != nil && tweet.extended_entities!.media != nil && tweet.extended_entities!.media!.count > 0{
            drawAdditionalImages(cell: cell, tweet: tweet)
        } else {

            cell.imageContainerHeightConstraint.constant = 0
        }
        return cell
    }
    
    func drawAdditionalImages(cell cell: TweetCell, tweet: Tweet){
        let margin: CGFloat = 8
        let marginBetweenImages: CGFloat = 1
        let containerWidth = self.tableView.frame.size.width - cell.avatarImage.frame.size.width - margin*2
        let imageCount = tweet.extended_entities!.media!.count
        let images = tweet.extended_entities!.media!.allObjects
        let divider: CGFloat = CGFloat(imageCount)
        let startX = CGFloat(0)
        let startY = CGFloat(0)
        var smallSize = CGFloat(0)
        if(imageCount > 1){
            smallSize = CGFloat(containerWidth - marginBetweenImages)/divider
        }
        let mainSize = (containerWidth - marginBetweenImages) - smallSize
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        
        cell.imageContainerHeightConstraint.constant = mainSize
        
        let mainView = UIImageView()
        mainView.frame = CGRectMake(startX, startY, mainSize, mainSize)
        mainView.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imagesContainer.addSubview(mainView)
        let tweetMedia =  images[0] as! Media
        let tweetImageURL = tweetMedia.media_url!
        let urlMedia = NSURL(string: tweetImageURL)
        mainView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
        
        for i in 1..<imageCount {
            let additionalView = UIImageView()
            additionalView.contentMode = UIViewContentMode.ScaleAspectFill
            additionalView.frame = CGRectMake(startX + mainSize + marginBetweenImages, startY + smallSize * CGFloat(i-1), smallSize, smallSize)
            cell.imagesContainer.addSubview(additionalView)
            let tweetMedia =  images[i] as! Media
            let tweetImageURL = tweetMedia.media_url!
            let urlMedia = NSURL(string: tweetImageURL)
            additionalView.sd_setImageWithURL(urlMedia, placeholderImage: UIImage(named: "PlaceholderImage") ,completed: block)
        }
    }
    
}

