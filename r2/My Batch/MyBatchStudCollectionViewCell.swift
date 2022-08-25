//
//  MyBatchStudCollectionViewCell.swift
//  r2
//
//  Created by NonStop io on 12/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class MyBatchStudCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var batchStudImageView: UIImageView!
    @IBOutlet var batchStudNameLbl: UILabel!
    
    override func layoutSubviews() {
        batchStudNameLbl.font = UIFont (name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        batchStudNameLbl.tintColor = UIColor.black
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.r2_faintGray.cgColor
        
        batchStudImageView.contentMode = UIViewContentMode.scaleAspectFill
        batchStudImageView.layer.cornerRadius = batchStudImageView.frame.size.width / 2
        batchStudImageView.clipsToBounds = true
        
        
    }
    
}
