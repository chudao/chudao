//
//  HomeViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/7/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate, UISearchBarDelegate {
    
    var userId: Int = -1
    var identity: String = "undefined"
    var authToken: String = "undefined"
    var sharedUserInfo = SharedUserInfo()

    
    @IBOutlet var searchRequirment: UISearchBar!
    @IBAction func search(sender: AnyObject) {
        if searchRequirment.text != nil && searchRequirment.text != ""{
            let data = [String(userId), searchRequirment.text!]
            performSegueWithIdentifier("homeToSearchResult", sender: data)
        }else{
            displayAlert("Invalid search", message: "Please enter a valid input", enterMoreInfo: false)
        }
    }
    @IBAction func newRequest(sender: AnyObject) {
        performSegueWithIdentifier("homeToNewRequest", sender: userId)
    }
    
    @IBOutlet var newRequestButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbc = tabBarController as! TabBarViewController
        sharedUserInfo = tbc.sharedUserInfo
        
        if tbc.sharedUserInfo.userId == -1 {
            sharedUserInfo.userId = userId
            sharedUserInfo.identity = identity
            sharedUserInfo.authToken = authToken
        }
        
        
        print("Homepage userid: \(sharedUserInfo.userId)")
        print("Homepage identity: \(sharedUserInfo.identity)")
        
        searchRequirment.delegate = self
        
        if identity != "user" {
            newRequestButton.enabled = false
            newRequestButton.tintColor = UIColor.clearColor();
        }
        
        //gesture to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //dismiss keyboard by clicking anywhere else
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //dimiss keyboard by pressing return key
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //display alert
    func displayAlert(title: String, message: String, enterMoreInfo: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var title = "Ok"
        if enterMoreInfo == true {
            title = "Cancel"
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) in
                
            }))
        }
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeToNewRequest" {
            let destinationViewController = segue.destinationViewController as! NewRequestViewController
            destinationViewController.userId = sender as! Int
            destinationViewController.authToken = self.authToken
            destinationViewController.identity = self.identity
        }
        if segue.identifier == "homeToSearchResult"{
            let destinationViewController = segue.destinationViewController as! UINavigationController
            let productSearchReultController = destinationViewController.topViewController as! ProductSearchResultTableViewController
            productSearchReultController.userId = Int(sender![0] as! String)!
            productSearchReultController.searchRequirement = sender![1] as! String
            productSearchReultController.authToken = self.authToken
            productSearchReultController.identity = self.identity
        }
    }

}
