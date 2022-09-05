//
//  QuizeListTableViewCell.swift
//  r2
//
//  Created by NonStop io on 21/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class QuizeListTableViewCell: UITableViewCell {
    
    @IBOutlet var quizeNumberLbl: UILabel!
    @IBOutlet var quizeTitleLbl: UILabel!
    @IBOutlet var quizeCreatedTimeLbl: UILabel!
    @IBOutlet var quizStatusButton: UIButton!
    @IBOutlet var quizViewAnswersButton: UIButton!
    
    @IBOutlet var quizScoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        quizeCreatedTimeLbl.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-5))
        
        quizeTitleLbl.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        quizeNumberLbl.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size+5))
        
        quizeTitleLbl.textColor = UIColor.r2_Body_Text_Color
        quizeCreatedTimeLbl.textColor = UIColor.r2_Sub_Text_Color
        
        quizStatusButton.titleLabel?.font =  UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-6))
        quizViewAnswersButton.titleLabel?.font =  UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-6))
        
        
        quizStatusButton.layer.cornerRadius = 4
        quizStatusButton.layer.borderWidth = 0.5
        quizStatusButton.layer.borderColor = UIColor.lightGray.cgColor
        
        quizViewAnswersButton.backgroundColor = UIColor.r2_Nav_Bar_Color
        quizViewAnswersButton.layer.cornerRadius = 4
        quizViewAnswersButton.layer.borderWidth = 0.5
        quizViewAnswersButton.layer.borderColor = UIColor.lightGray.cgColor
        
        quizScoreLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        quizScoreLabel.textColor = UIColor.r2_Sub_Text_Color
        
        self.selectedBackgroundView = UIView()
        self.selectionStyle = .none // you can also take this line out
        
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        self.selectedBackgroundView!.backgroundColor = selected ? .clear : nil
        
        // Configure the view for the selected state
    }
    
}
