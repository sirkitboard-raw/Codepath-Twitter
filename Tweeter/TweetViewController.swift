//
//  TweetViewController.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/29/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var profilePick: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoritesImageView: UIImageView!
    
    let likeTap = UITapGestureRecognizer()
    let replytap = UITapGestureRecognizer()
    let retweetTap = UITapGestureRecognizer()
    let profileTap = UITapGestureRecognizer()
    
    var tweet : Tweet?
    
    func likeTweet() {
        if(tweet!.favorited == true) {
            TwitterClient.sharedInstance.unlike(tweet!.id!, success: { () -> () in
                self.tweet!.favorited = !self.tweet!.favorited
                self.tweet?.likeCount = self.tweet!.likeCount - 1
                self.favoritesImageView.image = UIImage(named: "like")
                self.numFavorites.text = String(self.tweet!.likeCount)
            })
        } else {
            TwitterClient.sharedInstance.like(tweet!.id!, success: { () -> () in
                self.tweet!.favorited = !self.tweet!.favorited
                self.tweet?.likeCount = self.tweet!.likeCount + 1
                self.favoritesImageView.image = UIImage(named: "like_on")
                self.numFavorites.text = String(self.tweet!.likeCount)
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
                self.retweetImageView.image = UIImage(named: "retweet_on")
                self.tweet?.retweetCount = self.tweet!.retweetCount + 1
            }
            self.numRetweets.text = String(self.tweet!.retweetCount)
            
        })
    }
    
    func replyTweet() {
        performSegueWithIdentifier("replyCompose", sender: profilePick)

    }
    
    func goToUserProfile() {
        performSegueWithIdentifier("userClicked", sender: profilePick)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePick.setImageWithURL(tweet!.user!.profileURL!)
        name.text = tweet?.user?.name
        screenName.text = "@\(tweet!.user!.screenname!)"
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(tweet!.timestamp!)
        
        time.text = "\(dateString)"
        
        numRetweets.text = String(tweet!.retweetCount)
        numFavorites.text = String(tweet!.likeCount)
        
        if(tweet!.retweeted) {
            retweetImageView.image = UIImage(named: "retweet_on")
        } else {
            retweetImageView.image = UIImage(named: "retweet")
        }
        
        if(tweet!.favorited) {
            favoritesImageView.image = UIImage(named: "like_on")
        } else {
            favoritesImageView.image = UIImage(named: "like")
        }
        
        replyImageView.image = UIImage(named: "reply")
        
        text.text = tweet?.text
        
        likeTap.addTarget(self, action: "likeTweet")
        retweetTap.addTarget(self, action: "retweetTweet")
        profileTap.addTarget(self, action: "goToUserProfile")
        replytap.addTarget(self, action: "replyTweet")
        
        favoritesImageView.userInteractionEnabled = true
        retweetImageView.userInteractionEnabled = true
        profilePick.userInteractionEnabled = true
        replyImageView.userInteractionEnabled = true
        
        favoritesImageView.addGestureRecognizer(likeTap)
        retweetImageView.addGestureRecognizer(retweetTap)
        profilePick.addGestureRecognizer(profileTap)
        replyImageView.addGestureRecognizer(replytap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "replyCompose") {
            let vc = segue.destinationViewController as! ComposeViewController
            vc.user = User.currentUser
            vc.inReplyTo = tweet!.id!
            vc.replyUserName = tweet!.user!.screenname!
        }
        else {
            let vc = segue.destinationViewController as! UserViewController
            vc.user = tweet!.user
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
