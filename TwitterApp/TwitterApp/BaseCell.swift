//
//  BaseCell.swift
//  TwitterApp
//
//  Created by RWuser on 25/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class BaseCell: UITableViewCell {

    @IBOutlet weak var tweetCell: UIView!
    
    func configureCell(tweet: Tweet){
        if let cell = tweetCell as? ConfigureTweet {
            cell.configureTweet(tweet)
        }
    }
}
