//
//  HomeViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/7/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var userId: Int = -1

    @IBAction func newRequest(sender: AnyObject) {
        performSegueWithIdentifier("homeToNewRequest", sender: userId)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("homepage currentUser: \(userId)")
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
        if segue.identifier == "homeToNewRequest" {
            let destinationViewController = segue.destinationViewController as! NewRequestViewController
            destinationViewController.userId = sender as! Int
        }
    }

}
