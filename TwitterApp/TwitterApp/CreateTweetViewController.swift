//
//  CreateTweetViewController.swift
//  TwitterApp
//
//  Created by RWuser on 09/03/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
class CreateTweetViewController: UIViewController, UITextViewDelegate {
    let maxTweetSize = 140
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var SymbolsCountItem: UIBarButtonItem!
    
    @IBAction func TweetPressed(sender: AnyObject) {
        let text = tweetText.text
        if text.characters.count > 0 {
            NetworkService.createTweet(tweetText: text, success: {
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: {error in
                    NSLog("Error creating tweet")
            })
        }
    }
    
    override func viewDidLoad() {
        tweetText.delegate = self
        updateSymbolsCount()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newSize = textView.text.characters.count - range.length + text.characters.count
        if newSize > maxTweetSize {
            return false
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        updateSymbolsCount()
    }
    
    func updateSymbolsCount(){
        SymbolsCountItem.title = "\(tweetText.text.characters.count)"
    }
    
}