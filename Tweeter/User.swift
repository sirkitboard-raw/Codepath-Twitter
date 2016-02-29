//
//  User.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/21/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : String?
    var screenname : String?
    var profileURL : NSURL?
    var bannerURL : NSURL?
    var coverURL : NSURL?
    var numTweets : Int = 0
    var numFollowers : Int = 0
    var numFollowing : Int = 0
    var tagline : String?

    var dictionary : NSDictionary?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let profileUrlStr = profileUrlString {
            profileURL = NSURL(string: profileUrlStr)
        }
        
        if let profileBackgroundUrlString = profileBackgroundUrlString {
            bannerURL = NSURL(string: profileBackgroundUrlString)
        }
        
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
        numTweets = (dictionary["statuses_count"] as? Int) ?? 0
        numFollowers = (dictionary["followers_count"] as? Int) ?? 0
        numFollowing = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    static var _currentUser : User?
    
    class var currentUser: User? {
        get {
            if(_currentUser == nil) {
                let defaults = NSUserDefaults.standardUserDefaults()
            
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
        
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
        
            return _currentUser
        }
        set(user) {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary! , options: [])
                 defaults.setObject(data, forKey:"currentUserData")
            }
            else {
                defaults.setObject(nil, forKey:"currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    
}
