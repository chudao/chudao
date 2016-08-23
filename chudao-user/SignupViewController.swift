//
//  SignupViewController.swift
//  chudao
//
//  Created by xuanlin yang on 6/18/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var image: UIImageView!
    
    @IBAction func chooseExistingPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func takeNewPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style:.Default, handler: nil)
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func signup(sender: AnyObject) {
        if username.text == "" || email.text == "" || password.text == "" || password.text == "" {
            displayAlert("Field(s) are reqired", message: "Please fill in all the account information", enterMoreInfo: false)
        }else if email.text != confirmEmail.text {
            displayAlert("Email mismatch", message: "Please re-enter your email", enterMoreInfo: false)
        }else if password.text != confirmPassword.text {
            displayAlert("Password mismatch", message: "Please re-enter your password", enterMoreInfo: false)
        }else if age.text == "" || image.image == nil {
            displayAlert("Complete info will improve your experience", message: "Stylist could better recommend for you if you provide more information.  Do you still want to continue?", enterMoreInfo: true)
        }else {
            register()
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
    @IBOutlet var existingButton: UIButton!
    @IBOutlet var newButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var userId: Int = -1
    var identity: String = "user"
    var authToken: String = "undefined"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        age.layer.cornerRadius = 8.0
        age.layer.masksToBounds = true
        age.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        age.layer.borderWidth = 1.0
        
        gender.layer.cornerRadius = 8.0
        gender.layer.masksToBounds = true
        gender.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        gender.layer.borderWidth = 1.0
        
        username.layer.cornerRadius = 8.0
        username.layer.masksToBounds = true
        username.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        username.layer.borderWidth = 1.0
        
        email.layer.cornerRadius = 8.0
        email.layer.masksToBounds = true
        email.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        email.layer.borderWidth = 1.0
        
        confirmEmail.layer.cornerRadius = 8.0
        confirmEmail.layer.masksToBounds = true
        confirmEmail.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        confirmEmail.layer.borderWidth = 1.0
        
        password.layer.cornerRadius = 8.0
        password.layer.masksToBounds = true
        password.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        password.layer.borderWidth = 1.0
        
        confirmPassword.layer.cornerRadius = 8.0
        confirmPassword.layer.masksToBounds = true
        confirmPassword.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        confirmPassword.layer.borderWidth = 1.0
        
        existingButton.layer.cornerRadius = 8.0
        existingButton.layer.masksToBounds = true
        existingButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        existingButton.layer.borderWidth = 1.0
        
        newButton.layer.cornerRadius = 8.0
        newButton.layer.masksToBounds = true
        newButton.layer.borderColor = UIColor( red: 128/255, green: 128/255, blue:128/255, alpha: 1.0 ).CGColor
        newButton.layer.borderWidth = 1.0
        
        scrollView.delegate = self
        //scrollView.scrollEnabled = true;
        //scrollView.contentSize = CGSize(width:self.view.frame.width, height:2000.0)
        
        age.delegate=self
        username.delegate=self
        email.delegate=self
        confirmEmail.delegate=self
        password.delegate=self
        confirmPassword.delegate=self
        
        //gesture to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //activity indicator
        activityIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
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
                self.register()
            }))
        }
        
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.image.image = image
        self.image.clipsToBounds = true
        self.image.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func register() {
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/auth/register"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["user-name": self.username.text!, "password": self.password.text!, "user-category": self.identity]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
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
                        self.displayAlert("Error contacting server", message: "Not a 200 response, code: \((response as? NSHTTPURLResponse)?.statusCode)", enterMoreInfo: false)
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
                if jsonResponse["response-code"]! as! String == "010" {
                    self.userId = jsonResponse["user-id"]! as! Int
                    self.authToken = ((response as? NSHTTPURLResponse)?.allHeaderFields["X-Auth-Token"] as? String)!
                    self.uploadImage()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Unable to register", message: jsonResponse["response-message"]! as! String, enterMoreInfo: false)
                    }
                }
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }
    

    func uploadImage()
    {
        //activate activity indicator and disable user interaction
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        let url = NSURL(string: "http://chudao.herokuapp.com/binary/upload")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (image.image == nil)
        {
            print("image is nil")
            return
        }
        
        let image_data = UIImagePNGRepresentation(image.image!)
        
        if(image_data == nil)
        {
            print("image png representation is nil")
            return
        }
        
        
        let body = NSMutableData()
        
        let fname = "\(username.text!).png"
        
        let mimetype = "image/png"
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"user-id\"\r\n\r\n\(self.userId)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"product-id\"\r\n\r\n1\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData(image_data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"submit\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("submit\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            //disable activiy indicator and re-activate user interaction
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error: \(error!)")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Response: \(dataString!)")
            
            do{
                guard let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject] else{
                    print("Error reading JSON data")
                    return
                }
                if jsonResponse["response-code"]! as! String == "020" {
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Image uploaded: \(jsonResponse)")
                        self.performSegueWithIdentifier("signupToHome", sender: self.userId)
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Unable to register", message: jsonResponse["response-message"]! as! String, enterMoreInfo: false)
                    }
                }
            }catch  {
                print("error trying to convert data to JSON")
                return
            }

        }
        task.resume()
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signupToHome" {
            let destinationViewController = segue.destinationViewController as! UITabBarController
            let destinationTab = destinationViewController.viewControllers?.first as! HomeViewController
            destinationTab.userId = sender as! Int
            destinationTab.identity = identity
            destinationTab.authToken = authToken
        }
    }
    
}
