//
//  FeedHomeTableViewCell.swift
//  r2
//
//  Created by NonStop io on 20/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import YouTubePlayer

class FeedHomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet var backgroundCardView: UIView!
    @IBOutlet var feedPostedByProfilePic: UIImageView!
    @IBOutlet var feedPostedByNameLabel: UILabel!
    @IBOutlet var feedPostedTimeLabel: UILabel!
    @IBOutlet var feedPostedDescLabel: UILabel!
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 4
//            frame.size.height -= 2 * 5
//            super.frame = frame
//        }
//    }
    
    override func layoutSubviews() {
        
        backgroundCardView.layer.cornerRadius = 2.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width:0,height:0)
        backgroundCardView.layer.shadowOpacity = 0.8
        backgroundCardView.backgroundColor = UIColor(red:240/255.0,green:240/255.0,blue:240/255.0,alpha:1.0)
        
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
        
//        feedPostedByProfilePic.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
        
        feedPostedByProfilePic.contentMode = UIView.ContentMode.scaleAspectFill
        feedPostedByProfilePic.layer.cornerRadius = feedPostedByProfilePic.frame.size.width / 2
        feedPostedByProfilePic.clipsToBounds = true
        
        
        
//        feedPostedPicImageView.frame = CGRect(x:feedPostedDescLabel.frame.origin.x,y:feedPostedDescLabel.frame.origin.y+feedPostedDescLabel.frame.height,width:self.contentView.frame.width,height:self.contentView.frame.width)
//        feedPostedPicImageView.layer.masksToBounds = true
        
    }

}
