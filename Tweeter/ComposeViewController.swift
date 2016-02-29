//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/29/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var composedText: UITextView!
    
    var user : User?
    var inReplyTo : String?
    var replyUserName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.composedText.layer.borderWidth = 1.0;
        self.composedText.layer.borderColor = UIColor.grayColor().CGColor
        self.composedText.layer.cornerRadius = 5.0
        profilePic.setImageWithURL(user!.profileURL!)
        name.text = user!.name!
        if let replyUserName = replyUserName {
            composedText.text = "@\(replyUserName) "
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        var params : NSDictionary
        if let inReplyTo = inReplyTo {
            params = ["status":composedText.text, "in_reply_to_status_id": String(inReplyTo)]//, "in_reply_to_status_id": inReplyTo] as! NSDictionary
//            params.setValue(String(inReplyTo), forKey: "in_reply_to_status_id")
        } else {
            params = ["status":composedText.text]
        }
        TwitterClient.sharedInstance.compose(params) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
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
