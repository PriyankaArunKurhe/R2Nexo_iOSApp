//
//  ProfileTableViewCell.swift
//  r2
//
//  Created by NonStop io on 24/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var cellHeadingLabel: UILabel!
    @IBOutlet var cellIconImageView: UIImageView!
    @IBOutlet var cellNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
    }

}
