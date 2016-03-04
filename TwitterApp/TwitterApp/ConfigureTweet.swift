//
//  ComfigureTweetViewProtocol.swift
//  TwitterApp
//
//  Created by RWuser on 29/02/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
@objc protocol ConfigureTweet: class {
    func configureTweet(tweet: Tweet, tweetCellClickDelegate: TweeCellButtonsClickDelegate)
}

