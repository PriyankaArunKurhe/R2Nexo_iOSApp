//
//  LeaderboardListCellTableViewCell.swift
//  r2
//
//  Created by NonStop io on 05/02/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
//import QuartzCore

class LeaderboardListCellTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet var boostMebuttonTouch: UIButton!
    
    @IBOutlet var leadStuProfilePic: UIImageView!
    
    @IBOutlet var leadStuNameLabel: UILabel!
    
    @IBOutlet var leadStuScoreLabel: UILabel!
    
    @IBOutlet var leadStuRankLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leadStuNameLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        leadStuNameLabel.textColor = UIColor.r2_Nav_Bar_Color
        
        leadStuScoreLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        leadStuScoreLabel.textColor = UIColor.gray
        
        
        
        leadStuProfilePic.contentMode = UIView.ContentMode.scaleToFill
        leadStuProfilePic.layer.cornerRadius = leadStuProfilePic.frame.size.width / 2
        leadStuProfilePic.clipsToBounds = true
        
        leadStuRankLabel.backgroundColor = UIColor.white
        leadStuRankLabel.layer.cornerRadius = leadStuRankLabel.frame.width/2
        leadStuRankLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        leadStuRankLabel.textColor = UIColor.lightGray
        leadStuRankLabel.layer.borderColor = UIColor.r2_faintGray.cgColor
        leadStuRankLabel.layer.borderWidth = 2
        leadStuRankLabel.clipsToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
