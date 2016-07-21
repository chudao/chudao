//
//  ResponseProductDetailViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/21/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class ResponseProductDetailViewController: UIViewController {

    var userId: Int = -1
    var identity: String = "undefined"
    var authToken: String = "undefined"
    var productDetail: [[String:AnyObject]] = []
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productBrand: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBAction func done(sender: AnyObject) {
    }
    @IBAction func purchase(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
