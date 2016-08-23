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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var requestDetail: [[String:AnyObject]] = []
    var indexForTheEndOfRespondedRequest: Int = -1

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

        fetchRequests("responded")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //display alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestDetail.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellInRequest")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cellInRequest")
        }
        cell!.textLabel?.text = "Request +\(requestDetail[indexPath.row]["request-id"] as! String)"
        cell!.detailTextLabel?.text = requestDetail[indexPath.row]["status"] as? String
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("requestToViewResponse", sender: indexPath.row)
    }
    
    //fetch sent requests
    func fetchRequests(status: String){
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/query/request/user/status"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["status":status]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(self.sharedUserInfo.authToken, forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print("Request: \(postParams)")
        } catch {
            print("Error")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            //disable activiy indicator and re-activate user interaction
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Error contacting server", message: "Not a 200 response, code: \((response as? NSHTTPURLResponse)?.statusCode)")
                    }
                    return
            }
            
            // Read the JSON
            do{
                guard let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject] else{
                    print("Error reading JSON data")
                    return
                }
                print(jsonResponse)
                if jsonResponse["response-code"]! as! String == "040" {
                    let requestDetail = jsonResponse["response-data"] as? [[String:AnyObject]]
                    self.requestDetail += requestDetail!
                    if status == "responded"{
                        self.indexForTheEndOfRespondedRequest = requestDetail!.count - 1
                        self.fetchRequests("unresponded")
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    if status == "unresponded" && self.requestDetail.count <= 0{
                        dispatch_async(dispatch_get_main_queue()) {
                            self.displayAlert("No requests available", message: "Oops, you have not submitted any requests")
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Unable to query", message: jsonResponse["response-message"]! as! String)
                    }
                }
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "requestTabToNewRequest" {
            let destinationViewController = segue.destinationViewController as! NewRequestViewController
            destinationViewController.userId = sharedUserInfo.userId
            destinationViewController.authToken = sharedUserInfo.authToken
            destinationViewController.identity = sharedUserInfo.identity
            destinationViewController.username = sharedUserInfo.username
            destinationViewController.password = sharedUserInfo.password
        }
        
        if segue.identifier == "requestToViewResponse" {
            let destinationViewController = segue.destinationViewController as! ResponseViewController
            destinationViewController.userId = sharedUserInfo.userId
            destinationViewController.authToken = sharedUserInfo.authToken
            destinationViewController.identity = sharedUserInfo.identity
            destinationViewController.username = sharedUserInfo.username
            destinationViewController.password = sharedUserInfo.password
            destinationViewController.requestDetail = requestDetail[sender as! Int]
        }
    }

}
