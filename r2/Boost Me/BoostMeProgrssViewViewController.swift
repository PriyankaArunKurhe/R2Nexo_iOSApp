//
//  BoostMeProgrssViewViewController.swift
//  r2
//
//  Created by NonStop io on 16/03/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
import SDWebImage

class BoostMeProgrssViewViewController: UIViewController {
    
    @IBOutlet var Analysingandlistinglabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var backgroundImageView: UIImageView!
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gifURL = Bundle.main.url(forResource: "sample", withExtension: "gif")
        backgroundImageView.sd_setImage(with: gifURL)
        
        Analysingandlistinglabel.font = UIFont(name: Constants.r2_semi_bold_font, size: 15.0)
        Analysingandlistinglabel.textColor = UIColor.r2_Nav_Bar_Color
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.view.backgroundColor = UIColor.init(red: 99/255, green: 173/255, blue: 199/255, alpha: 1)
        //        rgb(99,173,199)
        progressView?.progressTintColor = UIColor.r2_Nav_Bar_Color
        if self.progressView?.progress != 0.75{
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(BoostMeProgrssViewViewController.updateProgress), userInfo: nil, repeats: true)
        }
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BoostMeSID") as! BoostMeViewController
            //            self.present(nextViewController, animated:true, completion:nil)
            //
            //            let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController() as! BoostMeViewController
            //            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            //            appDelegate.window?.rootViewController = initialViewController
            self.performSegue(withIdentifier: "BoostMeProgressToBoostMeVC", sender: self)
            self.view.removeFromSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateProgress() {
        //        progressView?.progress += 0.25
        UIView.animate(withDuration: 1, animations: {
            self.progressView?.setProgress(((self.progressView?.progress)! + 0.30), animated: true)
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
