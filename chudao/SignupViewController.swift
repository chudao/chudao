//
//  SignupViewController.swift
//  chudao
//
//  Created by xuanlin yang on 6/18/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate {

    @IBOutlet var isUserButton: CheckBox!
    @IBOutlet var isStylistButton: CheckBox!
    @IBAction func isUser(sender: AnyObject) {
        if isUserButton.isChecked == true {
            age.hidden = true
            gender.hidden = true
        }else{
            age.hidden = false
            gender.hidden = false
        }
    }
    @IBAction func isStylist(sender: AnyObject) {
        
    }
    @IBAction func signup(sender: AnyObject) {
        if username.text == "" || email.text == "" || password.text == "" || password.text == "" {
            displayAlert("Field(s) are reqired", message: "Please fill in all the account information", enterMoreInfo: false)
        }else if email.text != confirmEmail.text {
            displayAlert("Email mismatch", message: "Please re-enter your email", enterMoreInfo: false)
        }else if password.text != confirmPassword.text {
            displayAlert("Password mismatch", message: "Please re-enter your password", enterMoreInfo: false)
        }else{
            dispatch_async(dispatch_get_main_queue()) {
                self.displayAlert("Complete info will improve your experience", message: "Stylist could better recommend for you if you provide more information.  Do you still want to continue?", enterMoreInfo: true)
            }
            
        }
    }
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var age: UITextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var confirmEmail: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    var readyToSignup: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.scrollEnabled = true;
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:2000.0)
        
        age.hidden = true
        gender.hidden = true
        
        age.delegate=self
        username.delegate=self
        email.delegate=self
        confirmEmail.delegate=self
        password.delegate=self
        confirmPassword.delegate=self
        
        
        
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
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: nil))
        var title = "OK"
        if enterMoreInfo == true {
            title = "Cancel"
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { (action) in
                self.postDataToURL()
            }))
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func postDataToURL() {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/auth/register"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["username": self.username.text!, "password": self.password.text!]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                
                
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("signupToHome", sender: self)
//                self.dismissViewControllerAnimated(true, completion: nil)
            }


        }.resume()
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
