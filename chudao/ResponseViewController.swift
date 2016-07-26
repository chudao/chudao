//
//  ResponseViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/21/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate {
    
    var userId: Int = -1
    var authToken: String = "undefined"
    var identity: String = "undefined"
    var requestDetail: [String:AnyObject] = [:]
    var responseDetail: [String:AnyObject] = [:]
    var productDetail: [[String:AnyObject]] = []
    var requestSpecificImageAsData = NSData()
    var userImageAsData = NSData()
    var stylistImageAsData = NSData()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var userDefaultImage: UIImageView!
    @IBOutlet var requestSpecificImage: UIImageView!
    @IBOutlet var userNote: UITextView!
    @IBOutlet var stylistImage: UIImageView!
    @IBOutlet var stylistNote: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.scrollEnabled = true
        scrollView.sizeToFit()
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:950.0)
        
        if requestDetail["user-message"] as? String != "" {
            userNote.text = requestDetail["user-message"] as! String
        }
        
        if requestSpecificImageAsData == NSData() {
            if requestDetail["file-key"] as? String != "" {
                downLoadImage((requestDetail["file-key"] as? String)!, placeHolder: "requestSpecificImage")
            }
        }
        
        //activity indicator
        activityIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailViewController.imageTapped(_:)))
        userDefaultImage.userInteractionEnabled = true
        userDefaultImage.addGestureRecognizer(tapRecognizer)
        
        requestSpecificImage.userInteractionEnabled = true
        requestSpecificImage.addGestureRecognizer(tapRecognizer)
        
        stylistImage.userInteractionEnabled = true
        stylistImage.addGestureRecognizer(tapRecognizer)
        
        
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProductDetailViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    
    //download request image
    func downLoadImage(fileKey: String, placeHolder: String){
        
    }
    
    
    //fetch response detail
    func fetchResponse(responseId: String){
        
    }
    
    
    //Qury by productID for detail
    func queryByID(productId: String){
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/query/product/ids"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["product-ids": productId]
        
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
                    print("Response code: \((response as? NSHTTPURLResponse)?.statusCode)")
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
                    let productInfo = jsonResponse["response-data"] as? [[String:AnyObject]]
                    self.productDetail = productInfo!
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
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

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //display alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellInRequestResponseView", forIndexPath: indexPath)
        cell.textLabel?.text = productDetail[indexPath.row]["ProductName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("resultToProductDetail", sender: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "responseToProductDetail" {
            let destinationViewController = segue.destinationViewController as! ResponseProductDetailViewController
            destinationViewController.userId = userId
            destinationViewController.authToken = authToken
            destinationViewController.identity = identity
            destinationViewController.productDetail = productDetail
            destinationViewController.requestDetail = requestDetail
            destinationViewController.userImageAsData = userImageAsData
            destinationViewController.stylistImageAsData = stylistImageAsData
            destinationViewController.requestSpecificImageAsData = requestSpecificImageAsData
            destinationViewController.responseDetail = responseDetail
            destinationViewController.prodcutIndex = sender as! Int
        }
    }
}
