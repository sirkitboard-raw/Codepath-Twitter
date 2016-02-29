//
//  TweetCell.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/22/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class UserTweetTweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    let likeTap = UITapGestureRecognizer()
    let retweetTap = UITapGestureRecognizer()
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    var tweet: Tweet? {
        didSet {
            profilePic.setImageWithURL(tweet!.user!.profileURL!)
            displayName.text = tweet?.user?.name!
            name.text = "@\((tweet?.user?.screenname!)!)"
            
            let elapsedTime = NSDate().timeIntervalSinceDate(tweet!.timestamp!)
            var duration = Int(elapsedTime)
            var unit = "s"
            if(duration > 60) {
                duration = Int(duration/60)
                unit = "m"
            }
            if(duration > 60) {
                duration = Int(duration/60)
                unit = "h"
            }
            time.text = "\(duration)\(unit)"
            
            retweetCount.text = String(tweet!.retweetCount)
            likeCount.text = String(tweet!.likeCount)
            
            if(tweet!.retweeted) {
                retweetIcon.image = UIImage(named: "retweet_on")
            } else {
                retweetIcon.image = UIImage(named: "retweet")
            }
            
            if(tweet!.favorited) {
                likeIcon.image = UIImage(named: "like_on")
            } else {
                likeIcon.image = UIImage(named: "like")
            }
            
            tweetText.text = tweet?.text
            
            likeTap.addTarget(self, action: "likeTweet")
            retweetTap.addTarget(self, action: "retweetTweet")
            
            likeIcon.userInteractionEnabled = true
            retweetIcon.userInteractionEnabled = true
            likeIcon.addGestureRecognizer(likeTap)
            retweetIcon.addGestureRecognizer(retweetTap)
            
        }
    }
    
    func likeTweet() {
        //        tweet!.favorited = !tweet!.favorited
        //
        //
        //        if(tweet!.favorited) {
        //            tweet?.likeCount = tweet!.likeCount + 1
        //            likeIcon.image = UIImage(named: "like_on")
        //        } else {
        //            likeIcon.image = UIImage(named: "like")
        //            tweet?.likeCount = tweet!.likeCount - 1
        //        }
        //        likeCount.text = String(tweet!.likeCount)
        if(tweet!.favorited == true) {
            TwitterClient.sharedInstance.unlike(tweet!.id!, success: { () -> () in
                self.tweet!.favorited = !self.tweet!.favorited
                self.tweet?.likeCount = self.tweet!.likeCount - 1
                self.likeIcon.image = UIImage(named: "like")
                self.likeCount.text = String(self.tweet!.likeCount)
            })
        } else {
            TwitterClient.sharedInstance.like(tweet!.id!, success: { () -> () in
                self.tweet!.favorited = !self.tweet!.favorited
                self.tweet?.likeCount = self.tweet!.likeCount + 1
                self.likeIcon.image = UIImage(named: "like_on")
                self.likeCount.text = String(self.tweet!.likeCount)
            })
            
        }
    }
    
    func retweetTweet() {
        if(tweet?.retweeted == true) {
            return;
        }
        
        TwitterClient.sharedInstance.retweet(tweet!.id!, success: { () -> () in
            self.tweet!.retweeted = !self.tweet!.retweeted
            
            if(self.tweet!.retweeted) {
                self.retweetIcon.image = UIImage(named: "retweet_on")
                self.tweet?.retweetCount = self.tweet!.retweetCount + 1
            }
            self.retweetCount.text = String(self.tweet!.retweetCount)
            
        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
