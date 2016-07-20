//
//  RespondProductDetailViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/19/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class RespondProductDetailViewController: UIViewController {
    
    var userId: Int = -1
    var identity: String = "undefined"
    var authToken: String = "undefined"
    var productIndex: Int = -1
    var productDetail: [[String:AnyObject]] = []
    

    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productBrand: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBAction func done(sender: AnyObject) {
        performSegueWithIdentifier("productDetailToRespond", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("RespondProductDetailpage userid: \(userId)")
        print("RespondProductDetailpage identity: \(identity)")
        
        let image = UIImage(data: (productDetail[productIndex]["productImage"] as? NSData)!)
        productImage.image = image
        productImage.clipsToBounds = true
        productImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        productBrand.text = productDetail[productIndex]["productBrand"] as? String
        productName.text = productDetail[productIndex]["productName"] as? String
        productDescription.text = productDetail[productIndex]["productDescription"] as? String
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productDetailToRespond" {
            let destinationViewController = segue.destinationViewController as! RespondViewController
            destinationViewController.userId = userId
            destinationViewController.authToken = authToken
            destinationViewController.identity = identity
            destinationViewController.productDetail = productDetail
       }
    }

}
