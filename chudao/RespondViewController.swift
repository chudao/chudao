//
//  RespondViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/18/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class RespondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var userId: Int = -10
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var productDetail: [[String:AnyObject]] = []
    var authToken: String = "undefined"
    var identity: String = "undefined"

    @IBAction func finishResponding(sender: AnyObject) {
        performSegueWithIdentifier("respondToHome", sender: self)
    }
    @IBOutlet var searchRequirement: UISearchBar!
    @IBAction func search(sender: AnyObject) {
        if searchRequirement.text == "" {
            
        }else{
            performSegueWithIdentifier("respondToSearch", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        //activity indicator
        activityIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)

        //gesture to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            productDetail.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("respondToProductDetail", sender: indexPath.row)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForRespond", forIndexPath: indexPath)
        cell.textLabel?.text = productDetail[indexPath.row]["productName"] as? String
        cell.detailTextLabel?.text = productDetail[indexPath.row]["productBrand"] as? String
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "respondToHome" {
            let destinationViewController = segue.destinationViewController as! TabBarViewController
            var sharedUserInfo = SharedUserInfo()
            sharedUserInfo = destinationViewController.sharedUserInfo
            sharedUserInfo.userId = userId
            sharedUserInfo.identity = identity
            sharedUserInfo.authToken = authToken
            destinationViewController.switchTo = "3"
        }
        
        if segue.identifier == "respondToSearch" {
            let destinationViewController = segue.destinationViewController as! UINavigationController
            let productSearchReultController = destinationViewController.topViewController as! ProductSearchResultTableViewController
            productSearchReultController.userId = userId
            productSearchReultController.searchRequirement = searchRequirement.text!
            productSearchReultController.authToken = authToken
            productSearchReultController.identity = identity
            productSearchReultController.searchToAdd = true
        }

        if segue.identifier == "respondToProductDetail" {
            let destinationViewController = segue.destinationViewController as! RespondProductDetailViewController
            destinationViewController.authToken = authToken
            destinationViewController.identity = identity
            destinationViewController.userId = userId
            destinationViewController.productIndex = sender as! Int
            destinationViewController.productDetail = productDetail
        }
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

}
