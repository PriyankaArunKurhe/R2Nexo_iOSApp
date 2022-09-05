//
//  FeedDetailTableViewCell.swift
//  r2
//
//  Created by NonStop io on 01/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import YouTubePlayer

class FeedDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var feedDescTextView: UITextView!
    @IBOutlet var feedPostedByProfilePic: UIImageView!
    @IBOutlet var feedTitleLabel: UILabel!
    @IBOutlet var feedPostedTimeLabel: UILabel!
    @IBOutlet var feedPostedPicImageView: UIImageView!
    @IBOutlet var FeedPostedVideoView: YouTubePlayerView!
    @IBOutlet var FeedLikeButton: UIButton!
    @IBOutlet var FeedCommentButton: UIButton!
    @IBOutlet var FeedShareButton: UIButton!
    @IBOutlet var FeedBookmarkButton: UIButton!
    @IBOutlet var readMoreBtn: UIButton!
    @IBOutlet var FeedLikeCount: UILabel!
    @IBOutlet var FeedCommentCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedTitleLabel.sizeToFit()
        feedDescTextView.sizeToFit()
        feedDescTextView.isScrollEnabled = false
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        feedTitleLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        feedPostedTimeLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        feedDescTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        FeedLikeCount.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        FeedCommentCountLbl.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        feedPostedPicImageView.clipsToBounds = true
        feedDescTextView.textColor = UIColor.r2_Body_Text_Color
        FeedLikeCount.textColor = UIColor.r2_Body_Text_Color
        FeedCommentCountLbl.textColor = UIColor.r2_Body_Text_Color
        feedPostedTimeLabel.textColor = UIColor.r2_Sub_Text_Color
        feedTitleLabel.textColor = UIColor.r2_Nav_Bar_Color
    }
}
