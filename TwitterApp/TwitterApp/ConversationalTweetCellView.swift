//
//  ConversationalTweeCell.swift
//  TwitterApp
//
//  Created by RWuser on 24/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class ConversationalTweetCellView: UIView, ConfigureTweet{
    var mainView: UIView!
    let nibName = "ConversationalTweetCellView"
    
    @IBOutlet weak var startCell: TweetCellView!
    @IBOutlet weak var moreRepliesButton: UIButton!
    @IBOutlet weak var cell2: TweetCellView!
    @IBOutlet weak var cell3: TweetCellView!
    
    @IBOutlet weak var cell3NullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cell2NullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreRepliesButtonHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        mainView = bundle.loadNibNamed(nibName, owner: self, options: nil)[0] as! UIView
        addSubview(mainView)
        
        let horizontalConstraintLeading = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        
        let horizontalConstraintTrailing = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        
        let constraintTop = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        
        let constraintBottom = NSLayoutConstraint(item: mainView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        self.addConstraint(horizontalConstraintLeading)
        self.addConstraint(horizontalConstraintTrailing)
        self.addConstraint(constraintTop)
        self.addConstraint(constraintBottom)
    }
    
    func configureCell(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate) {
        //TODO: slow performance
        if let replies = Tweet.getRepliesToShowOnHome(tweet) {
            let count = replies.count
            switch count {
            case 0:
                cell2NullHeightConstraint.active = true
                cell3NullHeightConstraint.active = true
                moreRepliesButtonHeightConstraint.constant = 0
                moreRepliesButton.hidden = true
                
                startCell.topLineView.hidden = true
                startCell.bottomLineView.hidden = true
                
            case 1:
                cell2NullHeightConstraint.active = false
                cell3NullHeightConstraint.active = true
                moreRepliesButtonHeightConstraint.constant = 0
                moreRepliesButton.hidden = true
                
                cell2.configureCell(replies[0], tweetCellClickDelegate: tweetCellClickDelegate)
                
                cell2.topLineView.hidden = false
                cell2.bottomLineView.hidden = true
                startCell.topLineView.hidden = true
                startCell.bottomLineView.hidden = false
                
            case 2:
                cell2NullHeightConstraint.active = false
                cell3NullHeightConstraint.active = false
                moreRepliesButtonHeightConstraint.constant = 0
                moreRepliesButton.hidden = true
                cell2.configureCell(replies[0], tweetCellClickDelegate: tweetCellClickDelegate)
                cell3.configureCell(replies[1], tweetCellClickDelegate: tweetCellClickDelegate)
                
                cell2.topLineView.hidden = false
                cell2.bottomLineView.hidden = false
                cell3.topLineView.hidden = false
                cell3.bottomLineView.hidden = true
                startCell.topLineView.hidden = true
                startCell.bottomLineView.hidden = false
                
            default:
                cell2NullHeightConstraint.active = false
                cell3NullHeightConstraint.active = false
                moreRepliesButtonHeightConstraint.constant = 30
                moreRepliesButton.hidden = false
                cell2.configureCell(replies[count - 2], tweetCellClickDelegate: tweetCellClickDelegate)
                cell3.configureCell(replies[count - 1], tweetCellClickDelegate: tweetCellClickDelegate)
                
                cell2.topLineView.hidden = false
                cell2.bottomLineView.hidden = false
                cell3.topLineView.hidden = false
                cell3.bottomLineView.hidden = true
                startCell.topLineView.hidden = true
                startCell.bottomLineView.hidden = false
            }
            startCell.configureCell(tweet, tweetCellClickDelegate: tweetCellClickDelegate)
        }
        
    }
    
    func configureTweet(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate){
        configureCell(tweet, tweetCellClickDelegate: tweetCellClickDelegate)
    }
}