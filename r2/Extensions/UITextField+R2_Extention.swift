//
//  UITextField+R2_Extention.swift
//  r2
//
//  Created by NonStop io on 21/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
//    func setBottomBorder() {
//        self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.white.cgColor
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
//        
//    }
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func circularBorder(color: UIColor, width: CGFloat, corner_radius: CGFloat){
        
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:  self.frame.size.width, height: self.frame.size.height)
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner_radius
        self.layer.masksToBounds = true
        
    }
    
}
