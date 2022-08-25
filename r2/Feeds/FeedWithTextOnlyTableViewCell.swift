//
//  FeedWithTextOnlyTableViewCell.swift
//  r2
//
//  Created by NonStop io on 20/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class FeedWithTextOnlyTableViewCell: UITableViewCell {

    @IBOutlet var feedPostedByProfilePic: UIImageView!
    @IBOutlet var feedPostedByNameLabel: UILabel!
    @IBOutlet var feedPostedTimeLabel: UILabel!
    @IBOutlet var feedPostedDescLabel: UILabel!
    @IBOutlet var feedPostedPicImageView: UIImageView!
    
    @IBOutlet var FeedLikeButton: UIButton!
    @IBOutlet var FeedCommentButton: UIButton!
    @IBOutlet var FeedShareButton: UIButton!
    @IBOutlet var FeedBookmarkButton: UIButton!
    @IBOutlet var readMoreBtn: UIButton!
    
    @IBOutlet var FeedLikeCount: UILabel!
    @IBOutlet var FeedCommentCountLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        feedPostedByNameLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        feedPostedTimeLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        feedPostedDescLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        readMoreBtn.titleLabel?.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))!
        readMoreBtn.setTitleColor(UIColor.r2_Nav_Bar_Color, for: .normal)
        FeedLikeCount.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        FeedCommentCountLbl.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        feedPostedDescLabel.textColor = UIColor.r2_Body_Text_Color
        FeedLikeCount.textColor = UIColor.r2_Body_Text_Color
        FeedCommentCountLbl.textColor = UIColor.r2_Body_Text_Color
        feedPostedTimeLabel.textColor = UIColor.r2_Sub_Text_Color
        feedPostedByNameLabel.textColor = UIColor.r2_Nav_Bar_Color
        
        feedPostedByProfilePic.contentMode = UIViewContentMode.scaleAspectFill
        feedPostedByProfilePic.layer.cornerRadius = feedPostedByProfilePic.frame.size.width / 2
        feedPostedByProfilePic.clipsToBounds = true
   
        
    }
    
}
