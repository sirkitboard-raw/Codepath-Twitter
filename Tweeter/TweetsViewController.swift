//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/22/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                print("error \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let vc = segue.destinationViewController as! UserViewController
//        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
//        let user = tweets?[indexPath!.row].user
//        vc.user = user
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "compose") {
            let vc = segue.destinationViewController as! ComposeViewController
//            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
//            let tweet = tweets?[indexPath!.row]
            vc.user = User.currentUser
        }
        else {
            let vc = segue.destinationViewController as! TweetViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let tweet = tweets?[indexPath!.row]
            vc.tweet = tweet
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error:NSError) -> () in
                print("error \(error.localizedDescription)")
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
