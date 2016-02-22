//
//  LoginViewController.swift
//  Tweeter
//
//  Created by Aditya Balwani on 2/21/16.
//  Copyright © 2016 Aditya Balwani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBAction func onLogin(sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient.deauthorize()
        
        twitterClient.login({ () -> () in
            print("LOGIN, WOOO")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error:NSError) -> () in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
