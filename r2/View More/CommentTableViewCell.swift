//
//  CommentTableViewCell.swift
//  r2
//
//  Created by NonStop io on 31/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var commenterImage: UIImageView!    
    
    @IBOutlet var commenterNameLabel: UILabel!
    
    @IBOutlet var commentTextLabel: UILabel!
    
    @IBOutlet var commentTimeLabel: UILabel!
    
    @IBOutlet var commentCellBackgroundView: UIView!
    
    @IBOutlet var commentTimeSepretorLineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        commentCellBackgroundView.layer.cornerRadius = 2.0
        commentCellBackgroundView.layer.masksToBounds = false
        commentCellBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        commentTimeSepretorLineLabel.backgroundColor = UIColor(red:240/255.0,green:240/255.0,blue:240/255.0,alpha:1.0)
        commentCellBackgroundView.layer.shadowOffset = CGSize(width:0,height:0)
        commentCellBackgroundView.layer.shadowOpacity = 0.8
        commentCellBackgroundView.backgroundColor = UIColor.white
        
        commenterImage.contentMode = UIView.ContentMode.scaleAspectFill
        commenterImage.layer.cornerRadius = commenterImage.frame.size.width / 2
        commenterImage.clipsToBounds = true
        
        commenterNameLabel.textColor = UIColor.r2_Nav_Bar_Color
        commenterNameLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        commentTextLabel.textColor = UIColor.r2_Body_Text_Color
        commentTextLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        commentTimeLabel.textColor = UIColor.r2_Sub_Text_Color
        commentTimeLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-5))
        
    }

}
