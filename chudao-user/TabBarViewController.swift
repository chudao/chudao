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
        
        //set tab bar item selected images
        let tabBar = self.tabBar
        
        let homeSelectImage: UIImage! = UIImage(named: "homeTabSelected")?.imageWithRenderingMode(.AlwaysOriginal)
        let accountSelectImage: UIImage! = UIImage(named: "accountTabSelected")?.imageWithRenderingMode(.AlwaysOriginal)
        let requestSelectImage: UIImage! = UIImage(named: "requestTabSelected")?.imageWithRenderingMode(.AlwaysOriginal)
        
        tabBar.items![0].selectedImage = homeSelectImage
        tabBar.items![1].selectedImage = accountSelectImage
        tabBar.items![2].selectedImage = requestSelectImage
        
        tabBar.tintColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        if switchTo == "2"{
            self.selectedIndex = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
