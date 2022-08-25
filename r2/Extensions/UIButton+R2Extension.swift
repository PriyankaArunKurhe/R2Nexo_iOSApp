//
//  UIButton+R2Extension.swift
//  r2
//
//  Created by NonStop io on 19/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func circularBorder(color: UIColor, width: CGFloat, corner_radius: CGFloat){
        
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:  self.frame.size.width, height: self.frame.size.height)
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner_radius
        self.layer.masksToBounds = true
        
    }
    
}
