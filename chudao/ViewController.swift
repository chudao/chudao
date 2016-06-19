//
//  ViewController.swift
//  chudao
//
//  Created by xuanlin yang on 6/17/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBAction func loginButton(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("Missing Field(s)", message: "Username and password are required")
        }else{
            performSegueWithIdentifier("loginToHome", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate=self
        password.delegate=self
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
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}

