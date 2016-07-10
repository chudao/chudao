//
//  NewRequestViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/7/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class NewRequestViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var userId: Int = -1
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var fileKey: String = ""
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBAction func cancelRequest(sender: AnyObject) {
        performSegueWithIdentifier("newRequestToHome", sender: userId)
    }
    
    @IBOutlet var priceLowerBound: UITextField!
    @IBOutlet var priceHigherBound: UITextField!
    @IBOutlet var Requirements: UITextView!
    @IBOutlet var attachment: UIImageView!
    @IBAction func takeAnother(sender: AnyObject) {
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
    
    @IBAction func chooseExistingPhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func submitRequest(sender: AnyObject) {
        let lowerBound: Double? = Double(priceLowerBound.text!)
        let upperBound: Double? = Double(priceHigherBound.text!)
        
        if lowerBound != nil && upperBound != nil {
            if lowerBound > upperBound || lowerBound < 0.0 {
                displayAlert("Invalid price", message: "Please enter a valid range or leave it blank", enterMoreInfo: false)
            }
        }else if lowerBound != nil && lowerBound < 0.0 {
            displayAlert("Invalid price", message: "Please enter a valid lower bound or leave it blank", enterMoreInfo: false)
        }else if upperBound != nil && upperBound < 0.0 {
            displayAlert("Invalid price", message: "Please enter a valid upper bound or leave it blank", enterMoreInfo: false)
        }else if Requirements.text == "" {
            displayAlert("Description is required", message: "Please describe your requirements", enterMoreInfo: false)
        }else{
            dispatch_async(dispatch_get_main_queue()) {
                self.displayAlert("Complete info will improve your experience", message: "Stylist could better recommend for you if you provide more information.  Do you still want to continue?", enterMoreInfo: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("newRequest currentUser: \(userId)")
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
                self.uploadImage()
            }))
        }
        alert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.attachment.image = image
        self.attachment.clipsToBounds = true
        self.attachment.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func submit() {
        
        //activate activity indicator and disable user interaction
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://chudao.herokuapp.com/request/add"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        
        let postParams : [String: String] = ["user-id": String(self.userId), "user-message": self.Requirements.text!, "file-key": self.fileKey, "budget": "\(self.priceLowerBound.text!)-\(self.priceHigherBound.text!)", "product-tags":"toBeImplemented"]
        
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
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do{
                guard let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String: AnyObject] else{
                    print("Error reading JSON data")
                    return
                }
                print(jsonResponse)
                if jsonResponse["response-code"]! as! String == "050" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.cancelButton.title = "Home"
                        self.priceLowerBound.text = ""
                        self.priceHigherBound.text = ""
                        self.Requirements.text = ""
                        self.attachment.image = nil
                        self.displayAlert("Request submitted", message: "You request has been submitted, stylists are working on it.  Please return to home page or submit a new one", enterMoreInfo: false)
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
            }.resume()
    }
    
    
    func uploadImage()
    {
        let url = NSURL(string: "http://chudao.herokuapp.com/binary/upload")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if attachment.image == nil {
            print("image is nil")
            self.submit()
            return
        }
        
        let image_data = UIImagePNGRepresentation(attachment.image!)
        
        if image_data == nil {
            displayAlert("Unable to convert image", message: "Please select another image", enterMoreInfo: false)
            return
        }
        
        let body = NSMutableData()
        
        let fname = "User\(userId)Request\(Int(arc4random_uniform(100) + 1)).png"
        
        let mimetype = "image/png"
        
        
        //define the data post parameter

        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"user-id\"\r\n\r\n\(self.userId)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        body.appendData("Content-Disposition:form-data; name=\"user-message\"\r\n\r\n1\r\n".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)!)
        
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
        
        //activate activity indicator and disable user interaction
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let task = session.dataTaskWithRequest(request) { (let data, let response, let error) in
            
            //disable activiy indicator and re-activate user interaction
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
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
                    self.fileKey = jsonResponse["file-key"]! as! String
                    print("Image uploaded: \(jsonResponse)")
                    self.submit()
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayAlert("Unable to upload attachment", message: jsonResponse["response-message"]! as! String, enterMoreInfo: false)
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
        if segue.identifier == "newRequestToHome" {
            let destinationViewController = segue.destinationViewController as! UITabBarController
            let destinationTab = destinationViewController.viewControllers?.first as! HomeViewController
            destinationTab.userId = sender as! Int
        }
    }


}
