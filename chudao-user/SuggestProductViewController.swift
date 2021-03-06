//
//  SuggestProductViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/12/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class SuggestProductViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBAction func SubmitSuggestion(sender: AnyObject) {
        if productName.text == "" || brand.text == "" || purchaseLink.text == "" || productDescription.text == "" {
            displayAlert("Missing field(s)", message: "Please complete all fields before submitting")
        }else if !(purchaseLink.text?.containsString("http://"))! && !(purchaseLink.text?.containsString("https://"))! {
            displayAlert("Invalid link", message: "Please enter a valid HTTP protocal. http:// OR https://")
        }else if !((purchaseLink.text?.containsString("."))!){
            //find wildcard
            displayAlert("Invalid link", message: "Please provide a complete link")
        }else{
            submit()
        }
    }

    @IBAction func cancel(sender: AnyObject) {
        performSegueWithIdentifier("suggestToHome", sender: self)
    }
    @IBOutlet var productName: UITextField!
    @IBOutlet var brand: UITextField!
    @IBOutlet var purchaseLink: UITextField!
    @IBOutlet var productDescription: UITextView!
    @IBOutlet var tags: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var userId: Int = -1
    var authToken: String = "undefined"
    var identity:String = "undefined"
    var username: String = "undefined"
    var password:String = "undefined"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productName.layer.cornerRadius = 6.0
        productName.layer.masksToBounds = true
        productName.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        productName.layer.borderWidth = 0.5
        
        brand.layer.cornerRadius = 6.0
        brand.layer.masksToBounds = true
        brand.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        brand.layer.borderWidth = 0.5
        
        purchaseLink.layer.cornerRadius = 6.0
        purchaseLink.layer.masksToBounds = true
        purchaseLink.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        purchaseLink.layer.borderWidth = 0.5
        
        productDescription.layer.cornerRadius = 6.0
        productDescription.layer.masksToBounds = true
        productDescription.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        productDescription.layer.borderWidth = 0.5
        
        submitButton.layer.masksToBounds = true
        submitButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        submitButton.layer.borderWidth = 1.0
        
        print("Suggestpage serid: \(userId)")
        print("Suggestpage identity: \(identity)")
        
        productName.delegate = self
        brand.delegate = self
        productDescription.delegate = self
        tags.delegate = self
        
        //gesture to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //display alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    //Query by tag for productID
    func submit(){
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/product/add"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["product-name":productName.text!,"product-description":productDescription.text!,"product-brand":brand.text!,"product-tags": "undefined"]
        
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
                print("Response: \(jsonResponse)")
                if jsonResponse["response-code"]! as! String == "030" {
                    dispatch_async(dispatch_get_main_queue()) {
                            self.displayAlert("Submitted", message: "Thank you for the information, we are verifing it")
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Unable to submit", message: jsonResponse["response-message"]! as! String)
                    }
                }
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
            }.resume()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "suggestToHome" {
            let destinationViewController = segue.destinationViewController as! TabBarViewController
            var sharedUserInfo = SharedUserInfo()
            sharedUserInfo = destinationViewController.sharedUserInfo
            sharedUserInfo.userId = userId
            sharedUserInfo.identity = identity
            sharedUserInfo.authToken = authToken
            sharedUserInfo.username = username
            sharedUserInfo.password = password
            destinationViewController.switchTo = "2"
        }
    }
}
