//
//  AssignmentImgVdoTableCellTableViewCell.swift
//  r2
//
//  Created by NonStop io on 12/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//
import UIKit
import YouTubePlayer
class AssignmentImgVdoTableCellTableViewCell: UITableViewCell {
    @IBOutlet var AssignmentTitleLabel: UILabel!
    @IBOutlet var AssignmentCreatedDateTimeLabel: UILabel!
    @IBOutlet var AssignmentTextView: UITextView!
    @IBOutlet var AssignmentImageView: UIImageView!
    @IBOutlet var AssignmentVideo: YouTubePlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        AssignmentTitleLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        AssignmentCreatedDateTimeLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        AssignmentTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        AssignmentTextView.textColor = UIColor.r2_Body_Text_Color
        AssignmentCreatedDateTimeLabel.textColor = UIColor.r2_Sub_Text_Color
        AssignmentTitleLabel.textColor = UIColor.r2_Nav_Bar_Color
        AssignmentTextView.isScrollEnabled = false
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
