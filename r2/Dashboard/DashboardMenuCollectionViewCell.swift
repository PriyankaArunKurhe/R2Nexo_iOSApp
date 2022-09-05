//
//  DashboardMenuCollectionViewCell.swift
//  r2
//
//  Created by NonStop io on 08/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class DashboardMenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet var menuBackgroundImage: UIImageView!
    
    @IBOutlet var menuTitleLabel: UILabel!
    @IBOutlet var menuStatusCountLabel: UILabel!
    @IBOutlet var menuDoNowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuTitleLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size - 4))
        menuTitleLabel.textColor = UIColor.white
        
        menuStatusCountLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size - 4))
        menuStatusCountLabel.textColor = UIColor.white
        
//        quizeCreatedTimeLbl.textColor = UIColor.r2_Sub_Text_Color

//        menuBackgroundImage.dropShadow()
        
        
        // Initialization code
    }
}
