//
//  UserViewController.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/29/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var user : User?
    var tweets : [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerImage.setImageWithURL(user!.bannerURL!)
        userProfile.setImageWithURL(user!.profileURL!)
        userName.text = "@\(user!.screenname!)"
        numTweets.text = String(user!.numTweets)
        numFollowing.text = String(user!.numFollowing)
        numFollowers.text = String(user!.numFollowers)
        tableView.delegate = self
        tableView.dataSource = self
        TwitterClient.sharedInstance.userTimeline(user!.screenname!, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            print(self.tweets)
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                print("error")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        return 0
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
