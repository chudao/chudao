//
//  NewRequestViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/7/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class NewRequestViewController: UIViewController {

    var userId: Int = -1
    
    @IBAction func cancelRequest(sender: AnyObject) {
        performSegueWithIdentifier("newRequestToHome", sender: userId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("newRequest currentUser: \(userId)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newRequestToHome" {
            let destinationViewController = segue.destinationViewController as! HomeViewController
            destinationViewController.userId = sender as! Int
        }
    }


}
