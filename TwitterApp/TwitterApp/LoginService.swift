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
    
    static func getOAuthTwitter() -> OAuth1Swift? {
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
        
    static func saveCredentials(authorized authorized: Bool, accessToken: String, accessTokenSecret: String){
        NSUserDefaults.standardUserDefaults().setBool(authorized, forKey: LoginService.authorizedKey)
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: LoginService.accessTokenKey)
        NSUserDefaults.standardUserDefaults().setObject(accessTokenSecret, forKey: LoginService.accessTokenSecretKey)
    }
    
}