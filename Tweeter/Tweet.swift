//
//  Tweet.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/21/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text : String?
    var timestamp : NSDate?
    var retweetCount: Int = 0
    var likeCount: Int = 0
    var user: User?
    var id: String?

    var favorited: Bool
    var retweeted: Bool
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        likeCount = (dictionary["favorite_count"] as? Int) ?? 0
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        let timestamp_string = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        if let timeStampString = timestamp_string{
            timestamp = formatter.dateFromString(timeStampString)
        }
        
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
