//
//  UIImage+R2_Extention.swift
//  r2
//
//  Created by NonStop io on 04/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    func resize(_ size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        return redraw(in: rect)
    }
    
    func redraw(in rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return nil }
        
        context.draw(cgImage, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func circled(forRadius radius: CGFloat) -> UIImage? {
        let rediusSize = CGSize(width: radius, height: radius)
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: [.allCorners], cornerRadii: rediusSize)
        context.addPath(bezierPath.cgPath)
        context.clip()
        
        draw(in: rect)
        context.drawPath(using: .fillStroke)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
