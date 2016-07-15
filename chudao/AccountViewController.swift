//
//  AccountViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/14/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBAction func logout(sender: AnyObject) {
        performSegueWithIdentifier("accountToHome", sender: self)
    }
    @IBAction func suggest(sender: AnyObject) {
        performSegueWithIdentifier("accountToSuggest", sender: self)
    }
    
    var sharedUserInfo = SharedUserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbc = tabBarController as! TabBarViewController
        sharedUserInfo = tbc.sharedUserInfo
        
        print("Accountpage userid: \(sharedUserInfo.userId)")
        print("Accountpage identity: \(sharedUserInfo.identity)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accountToSuggest" {
            let detinationController = segue.destinationViewController as! SuggestProductViewController
            detinationController.userId = sharedUserInfo.userId
            detinationController.identity = sharedUserInfo.identity
            detinationController.authToken = sharedUserInfo.authToken
        }
    }
}
