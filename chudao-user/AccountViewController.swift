//
//  AccountViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/14/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {


    @IBAction func contact(sender: AnyObject) {
        performSegueWithIdentifier("accounToContanct", sender: self)
    }
    @IBAction func logout(sender: AnyObject) {
        performSegueWithIdentifier("accountToHome", sender: self)
    }
    @IBAction func suggest(sender: AnyObject) {
        performSegueWithIdentifier("accountToSuggest", sender: self)
    }
    
    @IBOutlet var suggestButton: UIButton!
    @IBOutlet var usernameText: UILabel!
    @IBOutlet var passwordText: UILabel!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var profilePic: UIImageView!
    
    var sharedUserInfo = SharedUserInfo()
    
    override func viewDidLoad() {
        suggestButton.layer.cornerRadius = 8.0
        suggestButton.layer.masksToBounds = true
        suggestButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        suggestButton.layer.borderWidth = 1.0
        
        contactButton.layer.cornerRadius = 8.0
        contactButton.layer.masksToBounds = true
        contactButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        contactButton.layer.borderWidth = 1.0
        
        logoutButton.layer.cornerRadius = 8.0
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        logoutButton.layer.borderWidth = 1.0
        
        super.viewDidLoad()
        
        let tbc = tabBarController as! TabBarViewController
        sharedUserInfo = tbc.sharedUserInfo
        
        usernameText.text = sharedUserInfo.username
        passwordText.text = sharedUserInfo.password
        
        print("Accountpage userid: \(sharedUserInfo.userId)")
        print("Accountpage identity: \(sharedUserInfo.identity)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accountToSuggest" {
            let detinationController = segue.destinationViewController as! SuggestProductViewController
            detinationController.userId = sharedUserInfo.userId
            detinationController.identity = sharedUserInfo.identity
            detinationController.authToken = sharedUserInfo.authToken
            detinationController.username = sharedUserInfo.username
            detinationController.password = sharedUserInfo.password
        }
        
        if segue.identifier == "accountToContact" {
            let detinationController = segue.destinationViewController as! ContactViewController
            detinationController.userId = sharedUserInfo.userId
            detinationController.identity = sharedUserInfo.identity
            detinationController.authToken = sharedUserInfo.authToken
            detinationController.username = sharedUserInfo.username
            detinationController.password = sharedUserInfo.password
        }
    }
}
