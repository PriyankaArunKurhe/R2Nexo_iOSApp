//
//  BoostMeViewController.swift
//  r2
//
//  Created by NonStop io on 16/03/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit

class BoostMeViewController: UIViewController {
    
    @IBOutlet var profilePicImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var companyCoverImage: UIImageView!
    
    
    @IBOutlet var pointsLabel: UILabel!
    
    @IBOutlet var instructionLabel: UILabel!
    
    
    @IBOutlet var takeQuizButton: UIButton!
    
    @IBOutlet var completeAssignButton: UIButton!
    
    @IBOutlet var readArticlBtn: UIButton!
    
    
    @IBOutlet var expertQuizBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        
        instructionLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-2))
        
        pointsLabel.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        
        takeQuizButton.titleLabel?.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        completeAssignButton.titleLabel?.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        readArticlBtn.titleLabel?.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        expertQuizBtn.titleLabel?.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        takeQuizButton.backgroundColor = .clear
        takeQuizButton.layer.cornerRadius = 5
        takeQuizButton.layer.borderWidth = 1
        takeQuizButton.layer.borderColor = UIColor.lightGray.cgColor
        
        completeAssignButton.backgroundColor = .clear
        completeAssignButton.layer.cornerRadius = 5
        completeAssignButton.layer.borderWidth = 1
        completeAssignButton.layer.borderColor = UIColor.lightGray.cgColor
        
        readArticlBtn.backgroundColor = .clear
        readArticlBtn.layer.cornerRadius = 5
        readArticlBtn.layer.borderWidth = 1
        readArticlBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        expertQuizBtn.backgroundColor = .clear
        expertQuizBtn.layer.cornerRadius = 5
        expertQuizBtn.layer.borderWidth = 1
        expertQuizBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        profilePicImageView.contentMode = UIView.ContentMode.scaleToFill
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2
        profilePicImageView.clipsToBounds = true
        
        nameLabel.text = "\(UserDefaults.standard.string(forKey: "user_first_name")! as String) \(UserDefaults.standard.string(forKey: "user_last_name")! as String)"
        profilePicImageView.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: "user_profile_pic_URL")! as String), placeholderImage: UIImage(named: "default_user.png"))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePendingQuizButtonTouch(_ sender: Any) {
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarSID") as! UITabBarController
        vc.selectedIndex = 2
        UserDefaults.standard.set(true, forKey: "isQuizList")
        self.present(vc, animated: true, completion: nil)
    
    }
    
    
    @IBAction func completeAssignmentBtnTouch(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarSID") as! UITabBarController
        vc.selectedIndex = 2
        UserDefaults.standard.set(false, forKey: "isQuizList")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func readArticleBtnTouch(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarSID") as! UITabBarController
        vc.selectedIndex = 1
        UserDefaults.standard.set(false, forKey: "isQuizList")
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


@IBDesignable
class DoubleImageButton: UIButton {
    /* Inspectable properties, once modified resets attributed title of the button */
    @IBInspectable var leftImg: UIImage? = nil {
        didSet {
            /* reset title */
            setAttributedTitle()
        }
    }
    
    @IBInspectable var rightImg: UIImage? = nil {
        didSet {
            /* reset title */
            setAttributedTitle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAttributedTitle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributedTitle()
    }
    
    private func setAttributedTitle() {
        var attributedTitle = NSMutableAttributedString()
        
        /* Attaching first image */
        if let leftImg = leftImg {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = leftImg
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            if let title = self.currentTitle {
                mutableAttributedString.append(NSAttributedString(string: title))
            }
            attributedTitle = mutableAttributedString
        }
        
        /* Attaching second image */
        if let rightImg = rightImg {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = rightImg
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            attributedTitle.append(mutableAttributedString)
        }
        
        /* Finally, lets have that two-imaged button! */
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
