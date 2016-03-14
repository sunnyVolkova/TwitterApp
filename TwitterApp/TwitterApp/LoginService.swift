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
    static let currentUserIdKey = "currentUserIdKey"
    
    static let consumerKey = "F4NRQDe9zolrd4kkfN0ckJZWD"
    static let consumerSecret = "bCckYkulnZeY8PP3x677VPcujgtXekjtCSCT2nceyvKFjSlFON"
    static let verifyCredentialsUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
    
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
    
    static func getCurrentUserId() -> Int? {
        return NSUserDefaults.standardUserDefaults().integerForKey(LoginService.currentUserIdKey)
    }
    
    static func verifyCredentials(success success: (Int) -> Void, failure: (ErrorType?) -> Void){
        let oauthswift = LoginService.oauthswift
        let authorized = NSUserDefaults.standardUserDefaults().boolForKey(LoginService.authorizedKey)
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(LoginService.accessTokenKey) as! String
        let accessTokenSecret = NSUserDefaults.standardUserDefaults().objectForKey(LoginService.accessTokenSecretKey) as! String
        if(authorized){
            oauthswift.client = OAuthSwiftClient(consumerKey: LoginService.consumerKey, consumerSecret: LoginService.consumerSecret, accessToken: accessToken, accessTokenSecret: accessTokenSecret)
            oauthswift.client.get(verifyCredentialsUrl, success: {
                data, response in
                if let user = DataService.parseAndStoreUserData(data) {
                    if let id = user.id as? Int {
                        NSUserDefaults.standardUserDefaults().setInteger(id, forKey: LoginService.currentUserIdKey)
                        success(id)
                        return
                    }
                }
                failure(nil)
                }, failure: {error in
                    NSLog("error \(error) \(error.userInfo)")
                    failure(error)
            })
        }
    }
    
}

extension NSUserDefaults {
    func hasKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    
    func integerForKey(key: String, defaultValue: Int) -> Int {
        if let objectForKey = objectForKey(key){
            if let integerForKey = objectForKey as? Int {
                return integerForKey
            }
        }
        return defaultValue
    }
    
    func integerForKey(key: String) -> Int? {
        if let objectForKey = objectForKey(key){
            if let integerForKey = objectForKey as? Int {
                return integerForKey
            }
        }
        return nil
    }
}