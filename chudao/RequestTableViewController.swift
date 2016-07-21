//
//  RequestTableViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/15/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class RequestTableViewController: UITableViewController {
    
    var sharedUserInfo = SharedUserInfo()
    var userId: Int = -1
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var authToken: String = "undefined"
    var identity: String = "undefined"

    @IBAction func newRequest(sender: AnyObject) {
        performSegueWithIdentifier("requestTabToNewRequest", sender: self)
    }
    
    @IBOutlet var newRequestButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbc = tabBarController as! TabBarViewController
        sharedUserInfo = tbc.sharedUserInfo
        
        print("Requestpage userid: \(sharedUserInfo.userId)")
        print("Requestpage identity: \(sharedUserInfo.identity)")
        
        if sharedUserInfo.identity != "user" {
            newRequestButton.enabled = false
            newRequestButton.tintColor = UIColor.clearColor();
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //fetch all the requests available on server
    func fetchRequest(){
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "requestTabToNewRequest" {
            let destinationViewController = segue.destinationViewController as! NewRequestViewController
            destinationViewController.userId = sharedUserInfo.userId
            destinationViewController.authToken = sharedUserInfo.authToken
            destinationViewController.identity = sharedUserInfo.identity
        }
        
        if segue.identifier == "requestToRespond" {
            let destinationViewController = segue.destinationViewController as! RespondViewController
            destinationViewController.userId = sharedUserInfo.userId
            destinationViewController.authToken = sharedUserInfo.authToken
            destinationViewController.identity = sharedUserInfo.identity
            // todo change to image data
            destinationViewController.responseDetail["userDefaultImage"] = NSData()
            destinationViewController.responseDetail["userDefaultImage"] = NSData()
            destinationViewController.responseDetail["userNote"] = ""
        }
        
        if segue.identifier == "requestToViewResponse" {
            let destinationViewController = segue.destinationViewController as! ResponseViewController
            
        }
    }

}
