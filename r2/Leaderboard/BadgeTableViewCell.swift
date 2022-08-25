//
//  BadgeTableViewCell.swift
//  r2
//
//  Created by NonStop io on 20/03/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {
    
    @IBOutlet var badgeImageView: UIImageView!
    
    @IBOutlet var badgeNameLabel: UILabel!
    
    @IBOutlet var badegDescLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        badgeNameLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        badgeNameLabel.textColor = UIColor.r2_Nav_Bar_Color
        
        badegDescLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        badegDescLabel.textColor = UIColor.gray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
