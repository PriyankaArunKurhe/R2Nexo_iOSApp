//
//  ChangePasswordViewController.swift
//  r2
//
//  Created by NonStop io on 03/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet var oldPasswordTextField: UITextField!
    
    @IBOutlet var newPasswordTextField: UITextField!
    
    @IBOutlet var confirmPassword: UITextField!
    
    @IBOutlet var changePasswordBtn: UIButton!
    
    @IBOutlet var DemoCircleImageView: UIImageView!
    
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        self.hideKeyboardWhenTappedAround()
        
        oldPasswordTextField.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        newPasswordTextField.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        confirmPassword.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: Constants.r2_font, size: 18)!
        ]
        
        oldPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes:attributes)
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes:attributes)
        confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes:attributes)
        
        changePasswordBtn.backgroundColor = UIColor.r2_Nav_Bar_Color
        let forgotBtnAttrs : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Constants.r2_bold_font, size: 18)!,
            NSAttributedString.Key.foregroundColor : UIColor.white]
        
        let attributeString = NSMutableAttributedString(string: "Update",
                                                        attributes: forgotBtnAttrs)
        changePasswordBtn.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func swipeToBack(sender:UISwipeGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func ChangePasswordButtonTouch(_ sender: Any) {
        
        if confirmPassword.text == newPasswordTextField.text {
            let alertController = UIAlertController(title: "Would You Like To Change Password?", message: "OK to confirm", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            }
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                self.changePassword()
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            self.presentAlertWithOkButton(withTitle: "New Password and Confirm Password does Not Match", message: "")
        }
    }
    
    func changePassword() {
        
        let newPassword = self.confirmPassword.text
        var confirmedPass = ""
        confirmedPass = newPassword!
        var stringWithoutWhiteSpace = confirmedPass.replacingOccurrences(of: "\n", with: "")
        stringWithoutWhiteSpace = stringWithoutWhiteSpace.replacingOccurrences(of: " ", with: "")
        print("string without space",stringWithoutWhiteSpace)
        
        confirmedPass = confirmedPass.replacingOccurrences(of: "\\", with: "\\%5C")
        confirmedPass = confirmedPass.replacingOccurrences(of: "\n", with: "\\n")
        confirmedPass = confirmedPass.replacingOccurrences(of: "&", with: "%26")
        confirmedPass = confirmedPass.replacingOccurrences(of: "\"", with: "\\%22")
        confirmedPass = confirmedPass.replacingOccurrences(of: "+", with: "%2B")
        confirmedPass = confirmedPass.replacingOccurrences(of: ";", with: "%3B")
        
        if confirmedPass != "" && stringWithoutWhiteSpace != "" {
            
            let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(self.oldPasswordTextField.text! as String)\", \"new_password\":\"\(confirmedPass)\"}" as NSString
            self.parsePostAPIWithParam(apiName: "change_password", paramStr: rawDataStr){  ResDictionary in
                let statusVal = ResDictionary["status"] as? String
                DispatchQueue.main.async {
                    if statusVal == "success"{
                        UserDefaults.standard.set(self.confirmPassword.text! as NSString, forKey: "userPassword")
                        let alertController = UIAlertController(title: "Password Changed Successfully", message: "", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        self.presentAlertWithOkButton(withTitle: (ResDictionary["message"] as? String)!, message: "")
                    }
                }
            }
            
        } else {
            self.showToast(message: "Blank Password Not allowed")
        }
        
    }
    
    @IBAction func UpdateProfile(_ sender: Any) {
        
        let imageProfCompressed = self.DemoCircleImageView.image?.resizeWith(width: 151)
        let imageProf = imageProfCompressed!.pngData()
        var imageProfStr = imageProf?.base64EncodedString()
        imageProfStr = imageProfStr?.replacingOccurrences(of: " ", with: "\n")
        
        let sizeofimg=imageProfStr?.count
        print("+++++",sizeofimg as Any)
        
        let rawDataStr: NSString = "data={\"email\":\"arnold@gmail.com\",\"password\":\"123123123\", \"first_name\":\"A\",\"last_name\":\"D\",\"new_password\":\"123123123\",\"picture_url\":\"\(imageProfStr!)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "update_profile", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    print("\n \n $$$$$$$ Sucess ")
                }
            }
        }
    }
    
    func parsePostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {
        var convertedJsonDictResponse:NSDictionary!
        let dataStr: NSString = paramStr
        let postData = NSMutableData(data: dataStr.data(using: String.Encoding.utf8.rawValue)!)
        let r2_URL = "\(Constants.r2_baseURL)\("/")\(apiName)\("/")"
        print("r2_URL",r2_URL)
        let request = NSMutableURLRequest(url: NSURL(string: r2_URL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = nil
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                do{
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        convertedJsonDictResponse = convertedJsonIntoDict.object(forKey: apiName) as? NSDictionary
                        print("\n \n response data convertedJsonDictResponse",convertedJsonDictResponse!)
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

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
