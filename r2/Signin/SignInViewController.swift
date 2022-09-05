//
//  SignInViewController.swift
//  r2
//
//  Created by NonStop io on 18/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import MessageUI

class SignInViewController: UIViewController,UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var scrollViewContainer: UIScrollView!
    @IBOutlet var signInScrollView: UIScrollView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var termsAndCondtionsButton: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var ForgotPasswordBtn: UIButton!
    @IBOutlet var loginButton: UIButton!
    var loginDetailsDict:[Any] = []
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.backgroundColor = UIColor(red: 255.0/255.0, green: 210.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        
        self.loginButton.titleLabel?.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size-1))
        
        self.loginButton.circularBorder(color: UIColor.clear, width: 1, corner_radius: self.loginButton.frame.size.height/2)
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        self.addDoneButtonOnKeyboard()
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        //        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"new_login_screen")!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch))
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "new_login_screen")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        //        signInInstructionLabel1.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size-2))
        //
        //        signInInstructionLabel1.tintColor = UIColor.darkGray
        //        PasswordLbl.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size-2))
        //        PasswordLbl.tintColor = UIColor.darkGray
        usernameTextField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        let image = UIImage(named: "icon-email-new")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        usernameTextField.leftView = imageView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        let image2 = UIImage(named: "icon-password-new")
        imageView2.image = image2
        imageView2.contentMode = .scaleAspectFit
        passwordTextField.leftView = imageView2
        usernameTextField.font = UIFont (name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        passwordTextField.font = UIFont (name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        usernameTextField.circularBorder(color: UIColor.black, width: 1, corner_radius: usernameTextField.frame.size.height/2)
        passwordTextField.circularBorder(color: UIColor.black, width: 1, corner_radius: usernameTextField.frame.size.height/2)
        //        usernameTextField.underlined()
        //        passwordTextField.underlined()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: Constants.r2_semi_bold_font, size: 17)!
        ]
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "  Enter your username", attributes:attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "  Enter your password", attributes:attributes)
        
        let forgotBtnAttrs : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont(name: Constants.r2_semi_bold_font, size: 14)!,
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: "Forgot Password?",
                                                        attributes: forgotBtnAttrs)
        ForgotPasswordBtn.setAttributedTitle(attributeString, for: .normal)
        usernameTextField.backgroundColor = UIColor.lightText
        passwordTextField.backgroundColor = UIColor.lightText
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "Internet Connection not Available!",
                                          message: "Please connect with internet and try again",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.x = 0//to lock horizontal scrolling
        //scrollView.contentOffset.y = 0//to lock vertical scrolling
    }
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
    //            let keyboardRectangle = keyboardFrame.cgRectValue
    //            let keyboardHeight = keyboardRectangle.height
    //            self.view.frame.origin.y -= keyboardHeight
    //        }
    //    }
    //
    //    @objc func keyboardWillHide(notification: NSNotification) {
    //        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
    //            let keyboardRectangle = keyboardFrame.cgRectValue
    //            let keyboardHeight = keyboardRectangle.height
    //            self.view.frame.origin.y += keyboardHeight
    //        }
    //    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.passwordTextField.inputAccessoryView = doneToolbar
        self.usernameTextField.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction()
    {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    
    @IBAction func signInButtonTouch(_ sender: Any) {       // to get login
        //        self.usernameTextField.text = "rauf@gmail.com"
        //        self.passwordTextField.text = "234"
        var deviceToken = ""
        DispatchQueue.main.async {
            if (UserDefaults.standard.string(forKey: "pushyToken") != nil){
                deviceToken = UserDefaults.standard.string(forKey: "pushyToken")! as String
            }
            self.activityProgress.startAnimating()
            
            if self.isValidEmail(self.usernameTextField.text!)  {
                if self.passwordTextField.text != "" {
                    
                    print("\n Device token in signin: \(deviceToken)")
                    let emailId = self.usernameTextField.text?.lowercased()
                    
                    let rawDataStr: NSString = "data={\"email\":\"\(emailId!)\",\"password\":\"\(self.passwordTextField.text! as NSString)\",\"device_type\":\"iOS\",\"device_token\": \"\(deviceToken)\"}" as NSString
                    // Calling
                    self.parsePostAPIWithParam(apiName: "login", paramStr: rawDataStr){  resDictionary in
                        let statusVal = resDictionary["status"] as? String
                        if statusVal == "success"{
                            
                            DispatchQueue.main.async {
                                self.activityProgress.stopAnimating()
                            }
                            let signInDetailDic = resDictionary["data"] as? NSDictionary
                            let studBatchId = signInDetailDic!["student_batch_id"] as? String
                            let studID = signInDetailDic!["student_id"] as? String
                            let studFirstName = signInDetailDic!["student_first_name"] as? String
                            let studLastName = signInDetailDic!["student_last_name"] as? String
                            
                            var studPicUrl = ""
                            studPicUrl = (signInDetailDic!["student_picture_url"] as? String)!
                            let studProfilePicURL = "\(Constants.r2_baseURL)\("/")\(studPicUrl)"
                            
                            //                                print("\n \(studFirstName) \n \(studLastName) \n \(studPicUrl) \n \(studProfilePicURL)")
                            
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(emailId! as NSString, forKey: "userID")
                                UserDefaults.standard.set(self.passwordTextField.text! as NSString, forKey: "userPassword")
                                UserDefaults.standard.set(studBatchId, forKey: "student_batch_id")
                                UserDefaults.standard.set(studID, forKey: "student_id")
                                
                                UserDefaults.standard.set(studFirstName, forKey: "user_first_name")
                                UserDefaults.standard.set(studLastName, forKey: "user_last_name")
                                UserDefaults.standard.set(studProfilePicURL, forKey: "user_profile_pic_URL")
                                
                                self.performSegue(withIdentifier: "loginToHomeTabBarController", sender: self)
                            }
                        }else {
                            DispatchQueue.main.async {
                                self.activityProgress.stopAnimating()
                            }
                            self.showToast(message: (resDictionary["message"] as? String)!)
                            self.presentAlertWithOkButton(withTitle: "Error in Login!", message: (resDictionary["message"] as? String)!)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.activityProgress.stopAnimating()
                    }
                    print("\n invalid password")
                    self.showToast(message: "NOT valid Password")
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x:self.passwordTextField.center.x - 10,y: self.passwordTextField.center.y))
                    animation.toValue = NSValue(cgPoint: CGPoint(x:self.passwordTextField.center.x + 10,y: self.passwordTextField.center.y))
                    self.passwordTextField.layer.add(animation, forKey: "position")
                }
            }else{
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                }
                print("\n invalid email")
                self.showToast(message: "NOT valid Username")
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x:self.usernameTextField.center.x - 10,y: self.usernameTextField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x:self.usernameTextField.center.x + 10,y: self.usernameTextField.center.y))
                self.usernameTextField.layer.add(animation, forKey: "position")
            }
        }
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func parsePostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {
        var convertedJsonDictResponse:NSDictionary!
        let dataStr: NSString = paramStr
        let postData = NSMutableData(data: dataStr.data(using: String.Encoding.utf8.rawValue)!)
        let r2_URL = "\(Constants.r2_baseURL)\("/")\(apiName)\("/")"
        print("r2_URL",r2_URL)
        print("\n data: ",paramStr)
        let request = NSMutableURLRequest(url: NSURL(string: r2_URL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = nil
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    self.presentAlertWithOkButton(withTitle: "Error in connection", message: "Error in connection. Please check your internet connection and try again.")
                    print("Error in connection. Please check your internet connection and try again.")
                }
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                do{
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        convertedJsonDictResponse = convertedJsonIntoDict.object(forKey: apiName) as? NSDictionary
                        print("\n \n response data convertedJsonDictResponse",convertedJsonDictResponse ?? "")
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                    print("Server Returns Status Code: \(httpResponse?.statusCode ?? 500)"+"\n")
                    self.showToast(message: "Server Returns Status Code: \(httpResponse?.statusCode ?? 500)" )
                    
                }
            }
        })
        dataTask.resume()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return logoImageView
    }
    @IBAction func forgotPasswordButtonTouch(_ sender: Any) {
        
        if (FileManager.default.ubiquityIdentityToken != nil) {
            self.sendForgotPasswordMail()
        }
        else {
            self.presentAlertWithOkButton(withTitle: "Email Account Not configured", message: "please configure your email and try again")
        }
    }
    func sendForgotPasswordMail()  {    // to send mail for new password request
        
        print("\n Forgot password ")
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            self.showToast(message: "No Email Account Found on this iPhone")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["rajiv@rsquareconsult.in"])
        //        composeVC.setToRecipients(["rauf.shaikh@nonstopio.com"])
        composeVC.setSubject("Regarding NexoR2 App - forgot password")
        composeVC.setMessageBody("Hi, I want to use the NexoR2 app, but I have forgotten my password. Kindly send me password.", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
