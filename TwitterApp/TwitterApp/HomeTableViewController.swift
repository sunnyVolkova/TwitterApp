//
//  HomeTableViewController.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class HomeTableViewController: UITableViewController{
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO:
        let cellIdentifier = "TweetCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TweetCell
        return cell
    }
    
}

