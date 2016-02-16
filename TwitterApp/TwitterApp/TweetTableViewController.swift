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
    var isConversationPresent = false;
    var tweet: Tweet? = nil
    let retweetedtweetCellIdentifier =  "Retweeted Cell"
    let tweetCellIdentifier = "MainTweetCell"
    let likeRetweetCellIdentifier = "Like Retweet Cell"
    let buttonsCellIdentifier = "Buttons Cell"
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
    }
    @IBAction func likeButtonPressed(sender: AnyObject) {
    }
    @IBAction func retweetButtonPressed(sender: AnyObject) {
    }
    @IBAction func replyButtonPressed(sender: AnyObject) {
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 20.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(isConversationPresent){
            return 2
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionsCount = 0
        if (section == 1) {
            sectionsCount = 2
            if tweet!.retweeted == 1 {
                sectionsCount += 1
            }
            if (tweet!.retweet_count!.integerValue > 0) || (tweet!.favorite_count?.integerValue > 0) {
                sectionsCount += 1
            }
        } else if (section == 2) {
            //TODO: add conversation
        }
        return sectionsCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        if(indexPath.section == 1){
            switch indexPath.row {
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier(retweetedtweetCellIdentifier, forIndexPath: indexPath)
                if tweet!.retweeted == 1 {
                    cell.textLabel?.text = "Retweeted by ...." //TODO: find
                } else {
                    cell.heightAnchor.constraintEqualToConstant(0)
                }
            case 2:
                let cell1 = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath)  as! ExtendedTweetCell
                configureCell(cell1)
                return cell1
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier(likeRetweetCellIdentifier, forIndexPath: indexPath)
                cell.textLabel?.text = "1 retweeted, 1 favorited" //TODO: find
            case 4:
                cell = tableView.dequeueReusableCellWithIdentifier(buttonsCellIdentifier, forIndexPath: indexPath)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! ExtendedTweetCell //TODO: fix it
            }
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! ExtendedTweetCell
        }
        return cell
    }
    
    func configureCell(cell: ExtendedTweetCell){
        cell.userName.text = tweet!.user?.name
        cell.tweetText.lineBreakMode = .ByWordWrapping
        cell.tweetText.numberOfLines = 0
        cell.tweetText.text = tweet!.text
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd' 'MMM' 'HH':'mm"
        cell.date.sizeToFit()
        cell.date.text = dateFormatter.stringFromDate(tweet!.created_at!)
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            if (error != nil){
                NSLog("error: \(error.description)")
            }
        }
        
        let url = NSURL(string: (tweet!.user?.profile_image_url)!)
        cell.avatarImage.sd_cancelCurrentImageLoad()
        cell.avatarImage.sd_setImageWithURL(url, placeholderImage: UIImage(named: "PlaceholderImage") , completed: block)
        for view in cell.imagesContainer.subviews{
            view.removeFromSuperview()
        }
        if tweet!.extended_entities != nil && tweet!.extended_entities!.media != nil && tweet!.extended_entities!.media!.count > 0{
            drawAdditionalImages(cell: cell, tweet: tweet!)
        } else {
            
            cell.imageContainerHeightConstraint.constant = 0
        }
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
