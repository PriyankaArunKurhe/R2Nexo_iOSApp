//
//  UIColor+CustomColor.swift
//  r2
//
//  Created by NonStop io on 18/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var customGreen: UIColor {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }
    
    class var r2_skyBlue: UIColor {
        let skyBlue = 0x03afef
        return UIColor.rgb(fromHex: skyBlue)        
    }
    
    class var r2_faintGray: UIColor {
        let faintGray = 0xedeced
        return UIColor.rgb(fromHex: faintGray)
    }
    
    class var r2_Nav_Bar_Color: UIColor {
        let Gray1 = 0x3C445D
        return UIColor.rgb(fromHex: Gray1)
    }
    
    class var r2_Tab_Bar_Color: UIColor {
        let Gray = 0x1A1E2A
        return UIColor.rgb(fromHex: Gray)
    }
    
    class var r2_Body_Text_Color: UIColor {
        let faintGray1 = 0x4A4A4A
        return UIColor.rgb(fromHex: faintGray1)
    }
    
    class var r2_Sub_Text_Color: UIColor {
        let faintGray2 = 0xC2C4CA
        return UIColor.rgb(fromHex: faintGray2)
    }
    
    class func rgb(fromHex: Int) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
