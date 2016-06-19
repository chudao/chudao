//
//  CheckBox.swift
//  chudao
//
//  Created by xuanlin yang on 6/18/16.
//  Copyright © 2016 chudao888. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
        //set images
        let checkedImage = UIImage(named: "checked")! as UIImage
        let uncheckedImage = UIImage(named: "unchecked")! as UIImage
        
        //bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, forState: .Normal)
                } else {
                    self.setImage(uncheckedImage, forState: .Normal)
                }
            }
        }
        
        override func awakeFromNib() {
            self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.isChecked = false
        }
        
        func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
}
