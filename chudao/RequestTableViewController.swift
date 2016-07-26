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
    var requestIds: [String] = []
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
        indexForTheEndOfRespondedRequest = requestIds.count - 1
        fetchRequests("unresponded")
        
        fetchRequestDetail(requestIds.joinWithSeparator(","))

        
        
        
    
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
        return requestIds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellInRequest", forIndexPath: indexPath)
        cell.textLabel?.text = "Request +\(requestIds[indexPath.row])"
        var status = "unresponded"
        if indexPath.row <= indexForTheEndOfRespondedRequest {
            status = "responded"
        }
        cell.detailTextLabel?.text = status
        return cell
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
        let postEndpoint: String = "http://chudao.herokuapp.com/query/XXXXXX"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["user-id": "\(userId)", "status":status]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(self.authToken, forHTTPHeaderField: "X-Auth-Token")
        
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
                    print("Not a 200 response, code: \((response as? NSHTTPURLResponse)?.statusCode)")
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
                    let requestIds = jsonResponse["response-data"] as? NSDictionary
                    if requestIds?.count > 0 {
                        self.requestIds += requestIds!["request-id"] as! [String]
                    }else{
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
    
    //fetch requet detail
    func fetchRequestDetail(requestIds: String){
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/query/XXXXXX"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["request-id": requestIds]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(self.authToken, forHTTPHeaderField: "X-Auth-Token")
        
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
                    print("Not a 200 response, code: \((response as? NSHTTPURLResponse)?.statusCode)")
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
                    if requestDetail?.count > 0 {
                        self.requestDetail = requestDetail!
                    }else{
                        dispatch_async(dispatch_get_main_queue()) {
                            self.displayAlert("Unable to query", message: "The request is lost")
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
        }
        
        if segue.identifier == "requestToViewResponse" {
            let destinationViewController = segue.destinationViewController as! ResponseViewController
            destinationViewController.userId = sharedUserInfo.userId
            destinationViewController.authToken = sharedUserInfo.authToken
            destinationViewController.identity = sharedUserInfo.identity
            destinationViewController.requestDetail = requestDetail[sender as! Int]
        }
    }

}
