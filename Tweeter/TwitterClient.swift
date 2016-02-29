//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/21/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "KSmgdBDYlG0fb29TSTtLfGuJg", consumerSecret: "VylPHcZby3djg9xJ3u1aO6bdHWyJG5l5bZWTjN4czKFw6g8UiV")
    
    var loginSuccess: (() -> ())?
    
    var loginFail: ((NSError) -> ())?
    
    func currentAccount(success: (User)->(), failure: (NSError)->()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
            }
        )
    }
    
    func userTimeline(userID: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let params = ["screen_name": userID] as NSDictionary
        GET("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
            }
        )
    }
    
    func login(success: ()->(), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFail = failure
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            }) {(error: NSError!) -> Void in
                failure(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
    func retweet(id: String, success: ()->()) {
        let params = ["id": id] as NSDictionary
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }) { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                print("error \(error.localizedDescription)")
        }

    }
    
    func like(id: String, success: ()->()) {
        let params = ["id": id] as NSDictionary
        
        POST("1.1/favorites/create.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success()
            }) { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                print("error \(error.localizedDescription)")
        }
    }
    
    func unlike(id: String, success: ()->()) {
        let params = ["id": id] as NSDictionary
        POST("1.1/favorites/destroy.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }) { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                print("error \(error.localizedDescription)")
        }
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            self.currentAccount({ (user:User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error:NSError) -> () in
                    self.loginFail?(error)
            })
            self.loginSuccess?()
        }) {(error: NSError!) -> Void in
            print("ERROR")
        }
    }
    
    func compose(params: NSDictionary, success: ()->()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }) { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                print("error \(error.localizedDescription)")
        }
    }

}
