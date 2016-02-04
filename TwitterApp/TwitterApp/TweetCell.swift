//
//  TweetCell.swift
//  TwitterApp
//
//  Created by RWuser on 28/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell{
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mediaContentView: UIStackView!
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.mediaContentView!.frame = CGRectMake(5,5,10,10)
//        NSLog("layoutSubviews")
////        //let limgW =  self.mediaContentView!.size.width;
////        if(self.mediaContentView.hidden == true) {
////            self.mediaContentView.frame = CGRectMake(self.avatarImage!.frame.width,
////                self.tweetText.frame.origin.y + self.tweetText.frame.height,
////                self.tweetText.frame.width,
////                0)
////        } else {
////            self.mediaContentView.frame = CGRectMake(self.avatarImage!.frame.width,
////                self.tweetText.frame.origin.y + self.tweetText.frame.height,
////                self.tweetText.frame.width,
////                self.mainImage.frame.height)
////        }
//    }
}

