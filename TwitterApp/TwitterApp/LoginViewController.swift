//
//  ViewController.swift
//  TwitterApp
//
//  Created by RWuser on 27/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            NetworkService.oauthswift = LoginService.getOAuthTwitter()!
            performSegueWithIdentifier("LoginSuccess", sender: nil)
        }
    }
    
    func doOAuthTwitter(){
        LoginService.oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
        LoginService.oauthswift.authorizeWithCallbackURL( NSURL(string: "twitterApp://oauth-callback/twitter")!, success: {
            credential, response, parameters in
            LoginService.saveCredentials(authorized: true, accessToken: credential.oauth_token, accessTokenSecret: credential.oauth_token_secret)
            self.updateUI(true)
            }, failure: { error in
                print(error.localizedDescription)
                LoginService.saveCredentials(authorized: false, accessToken: "", accessTokenSecret: "")
                self.updateUI(false)
            }
        )
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauth_token_secret)"
        }
        self.showAlertView(name ?? "Service", message: message)
    }

}

