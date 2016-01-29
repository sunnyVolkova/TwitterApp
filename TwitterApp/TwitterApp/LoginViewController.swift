//
//  ViewController.swift
//  TwitterApp
//
//  Created by RWuser on 27/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let authorizedKey = "authorizedKey"
    let accessTokenKey = "accessTokenKey"
    let accessTokenSecretKey = "accessTokenSecretKey"
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let authorized = NSUserDefaults.standardUserDefaults().boolForKey(self.authorizedKey)
        updateUI(authorized)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func login(sender: UIButton) {
            doOAuthTwitter()
    }
    

    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateUI(authorized: Bool){
        if(authorized){
            loginButton.hidden = true
            NetworkService.oauthswift = getOAuthTwitter()!
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeTableViewController")
            self.presentViewController(homeViewController!, animated: true, completion: nil)
        } else {
            loginButton.hidden = false
        }
    }

}

