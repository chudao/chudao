//
//  TabBarViewController.swift
//  chudao
//
//  Created by xuanlin yang on 7/14/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    let sharedUserInfo = SharedUserInfo()
    var switchTo: String = "-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if switchTo == "3"{
            self.selectedIndex = 2
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
