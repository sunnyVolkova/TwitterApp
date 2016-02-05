//
//  File.swift
//  TwitterApp
//
//  Created by RWuser on 27/01/16.
//  Copyright © 2016 RWuser. All rights reserved.
//

import Foundation
import OAuthSwift

class LoginService {
    static let authorizedKey = "authorizedKey"
    static let accessTokenKey = "accessTokenKey"
    static let accessTokenSecretKey = "accessTokenSecretKey"
    
    static let consumerKey = "F4NRQDe9zolrd4kkfN0ckJZWD"
    static let consumerSecret = "bCckYkulnZeY8PP3x677VPcujgtXekjtCSCT2nceyvKFjSlFON"
    
    static let oauthswift = OAuth1Swift(
        consumerKey:    consumerKey,
        consumerSecret: consumerSecret,
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl:    "https://api.twitter.com/oauth/authorize",
        accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
    )
    
    static func getOAuthTwitter() -> OAuth1Swift?{
        let oauthswift = LoginService.oauthswift
        let authorized = NSUserDefaults.standardUserDefaults().boolForKey(LoginService.authorizedKey)
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(LoginService.accessTokenKey) as! String
        let accessTokenSecret = NSUserDefaults.standardUserDefaults().objectForKey(LoginService.accessTokenSecretKey) as! String
        if(authorized){
            oauthswift.client = OAuthSwiftClient(consumerKey: LoginService.consumerKey, consumerSecret: LoginService.consumerSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
            return oauthswift
        } else {
            return nil
        }
    }
    
}

// MARK: - do authentification
extension LoginViewController {
    func doOAuthTwitter(){
        LoginService.oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
        LoginService.oauthswift.authorizeWithCallbackURL( NSURL(string: "twitterApp://oauth-callback/twitter")!, success: {
            credential, response, parameters in
            self.saveCredentials(authorized: true, accessToken: credential.oauth_token, accessTokenSecret: credential.oauth_token_secret)
            self.updateUI(true)
            self.showTokenAlert("name", credential: credential)
            }, failure: { error in
                print(error.localizedDescription)
                self.saveCredentials(authorized: false, accessToken: "", accessTokenSecret: "")
                self.updateUI(false)
            }
        )
    }
    
    func saveCredentials(authorized authorized: Bool, accessToken: String, accessTokenSecret: String){
        NSUserDefaults.standardUserDefaults().setBool(authorized, forKey: LoginService.authorizedKey)
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: LoginService.accessTokenKey)
        NSUserDefaults.standardUserDefaults().setObject(accessTokenSecret, forKey: LoginService.accessTokenSecretKey)
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauth_token_secret)"
        }
        self.showAlertView(name ?? "Service", message: message)
    }
    
    //TODO: remove later
    func testTwitter(oauthswift: OAuth1Swift) {
        oauthswift.client.get("https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: [:],
            success: {
                data, response in
                let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(jsonDict)
            }, failure: { error in
                print(error)
        })
    }
    
}
