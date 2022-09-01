//
//  NotificationTableViewCell.swift
//  r2
//
//  Created by NonStop io on 27/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var NotifImageView: UIImageView!
    @IBOutlet var NotificationTextLabel: UILabel!
    @IBOutlet var NotifTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotifImageView.contentMode = UIView.ContentMode.scaleToFill
        NotifImageView.layer.cornerRadius = NotifImageView.frame.size.width / 2
        NotifImageView.clipsToBounds = true
        NotifTimeLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-5))
        NotificationTextLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        NotificationTextLabel.textColor = UIColor.r2_Body_Text_Color
        NotifTimeLabel.textColor = UIColor.r2_Sub_Text_Color
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
