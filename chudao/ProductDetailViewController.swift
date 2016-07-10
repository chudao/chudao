//
//  ProductDetailViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/9/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var userId: Int = -1
    var productId: String = ""
    var productName: String = ""
    var productBrand: String = ""
    var productLink: String = ""
    var productDescription: String = ""

    @IBAction func done(sender: AnyObject) {
         performSegueWithIdentifier("productDetailToSearchResult", sender: userId)
    }
    
    @IBOutlet var productImage: UIImageView!

    @IBOutlet var brand: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var descriptionInfo: UILabel!
    @IBAction func purchase(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        brand.text = productBrand
        descriptionInfo.text = productDescription
        name.text = productName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productDetailToSearchResult" {
            let destinationViewController = segue.destinationViewController as! ProductSearchResultTableViewController
            destinationViewController.userId = sender as! Int
        }
    }
}
