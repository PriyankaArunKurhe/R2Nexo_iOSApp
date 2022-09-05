//
//  ApplicationFormViewController.swift
//  r2
//
//  Created by NonStop io on 16/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ApplicationFormViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var topicNameLabel: UILabel!
    @IBOutlet var topicNameTextView: UITextView!
    @IBOutlet var instanceWhereLabel: UILabel!
    @IBOutlet var instanceWhereTextView: UITextView!
    @IBOutlet var dateAppliedLabel: UILabel!
    @IBOutlet var dateAppliedTextView: UITextView!
    @IBOutlet var whatWasEffectLabel: UILabel!
    @IBOutlet var whatWasEffectTextView: UITextView!
    @IBOutlet var whatWentWellLabel: UILabel!
    @IBOutlet var whatWentWellTextView: UITextView!
    @IBOutlet var whatNotGoesExpectedLabel: UILabel!
    @IBOutlet var whatNotGoesExpectedTextView: UITextView!
    @IBOutlet var reflectionLabel: UILabel!
    @IBOutlet var reflectionTextView: UITextView!
    @IBOutlet var doDifferentLabel: UILabel!
    @IBOutlet var doDifferentTextView: UITextView!
    @IBOutlet var submitApplicationButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var sepretorView: UIView!
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    let datePickerView  : UIDatePicker = UIDatePicker(frame: CGRect(x:0, y:40, width:0, height:0))
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    let refreshControl = UIRefreshControl()
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    var ApplicationDic:[Any] = []
    var questionArray = ["Topic Name","Instance where applied?","Date applied","What was the effect?","What went well ?","What did not go as expected?","Reflections","What will I do differently next time?"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.containerView.addBottomBorderWithColor(color: UIColor.r2_faintGray, width: 1)
        self.topicNameTextView.text = UserDefaults.standard.string(forKey: "ApplicationTopicTitle")! as String
        self.title = self.topicNameTextView.text.capitalized
        self.topicNameTextView.isEditable = false
        self.topicNameTextView.backgroundColor = UIColor.r2_faintGray
        
        self.dateAppliedTextView.tag = 234
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.addDoneButtonOnKeyboard()
        
        instanceWhereTextView.delegate = self
        dateAppliedTextView.delegate = self
        doDifferentTextView.delegate = self
        reflectionTextView.delegate = self
        whatNotGoesExpectedTextView.delegate = self
        whatWasEffectTextView.delegate = self
        
        self.submitApplicationButton.backgroundColor = UIColor.r2_Nav_Bar_Color
        self.submitApplicationButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        
        self.designView()
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
       
        self.navigationController?.navigationBar.barTintColor = UIColor.r2_Nav_Bar_Color
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        
        scrollView.addSubview(refreshControl)
        print("\n topic ID in Application Form: \(UserDefaults.standard.string(forKey: "applicationTopicID")! as String)")
        
        if UserDefaults.standard.string(forKey: "isApplicationEditable")! as String == "True"{
            self.submitApplicationButton.isHidden = false
            sepretorView.isHidden = true
            scoreLabel.isHidden = true
            self.TextViewEnable()
            
        }else{
            self.submitApplicationButton.isHidden = true
            sepretorView.isHidden = false
            scoreLabel.isHidden = false
            self.viewAppAnswers()
            self.TextViewDisable()
        }
        
    }
        override func viewWillAppear(_ animated: Bool) {
        
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    
    @objc func refresh(){
        print("\n\n Refresh func call \n \n")
        refreshControl.endRefreshing()
    }
    
    func TextViewDisable() {
            self.instanceWhereTextView.isUserInteractionEnabled = false
            self.dateAppliedTextView.isUserInteractionEnabled = false
            self.whatWasEffectTextView.isUserInteractionEnabled = false
            self.whatWentWellTextView.isUserInteractionEnabled = false
            self.whatNotGoesExpectedTextView.isUserInteractionEnabled = false
            self.reflectionTextView.isUserInteractionEnabled = false
            self.doDifferentTextView.isUserInteractionEnabled = false
    }
    
    func TextViewEnable() {
        self.instanceWhereTextView.isUserInteractionEnabled = true
        self.dateAppliedTextView.isUserInteractionEnabled = true
        self.whatWasEffectTextView.isUserInteractionEnabled = true
        self.whatWentWellTextView.isUserInteractionEnabled = true
        self.whatNotGoesExpectedTextView.isUserInteractionEnabled = true
        self.reflectionTextView.isUserInteractionEnabled = true
        self.doDifferentTextView.isUserInteractionEnabled = true
    }
    func designView() {
        
        scoreLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        scoreLabel.textColor = UIColor.r2_Nav_Bar_Color
        
        topicNameLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        topicNameLabel.textColor = UIColor.r2_Nav_Bar_Color
        topicNameTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        
        instanceWhereLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        instanceWhereLabel.textColor = UIColor.r2_Nav_Bar_Color
        instanceWhereTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        dateAppliedLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        dateAppliedLabel.textColor = UIColor.r2_Nav_Bar_Color
        dateAppliedTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        whatWasEffectLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        whatWasEffectLabel.textColor = UIColor.r2_Nav_Bar_Color
        whatWasEffectTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        whatWentWellLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        whatWentWellLabel.textColor = UIColor.r2_Nav_Bar_Color
        whatWentWellTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        whatNotGoesExpectedLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        whatNotGoesExpectedLabel.textColor = UIColor.r2_Nav_Bar_Color
        whatNotGoesExpectedTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        reflectionLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        reflectionLabel.textColor = UIColor.r2_Nav_Bar_Color
        reflectionTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))
        
        doDifferentLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        doDifferentLabel.textColor = UIColor.r2_Nav_Bar_Color
        doDifferentTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-2))       
        
        
        self.setCircularboderToTextView()
        
    }
    
    func setCircularboderToTextView() {
        instanceWhereTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        reflectionTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        whatNotGoesExpectedTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        whatWentWellTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        whatWasEffectTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        dateAppliedTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        topicNameTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
        doDifferentTextView.circularBorder(color: UIColor.r2_faintGray, width: 2, corner_radius: 6)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        //        done.tintColor = UIColor.r2_Nav_Bar_Color
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.instanceWhereTextView.inputAccessoryView = doneToolbar
//        self.dateAppliedTextView.inputAccessoryView = doneToolbar
        self.whatWasEffectTextView.inputAccessoryView = doneToolbar
        self.whatWentWellTextView.inputAccessoryView = doneToolbar
        self.whatNotGoesExpectedTextView.inputAccessoryView = doneToolbar
        self.reflectionTextView.inputAccessoryView = doneToolbar
        self.doDifferentTextView.inputAccessoryView = doneToolbar
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text != nil && textView.text != " ") {
            //            self.sendCommentButton.isHidden = false
        }else{
            //            self.sendCommentButton.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        textView.textColor = UIColor.black
        
//        if textView.tag == 234 {
//            self.doDatePicker()
//        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
                if textView.tag == 234 {
                    self.doDatePicker()
                }
        return true
    }
    
    @IBAction func openDatePickerButtonTouch(_ sender: Any) {
        
//        self.doDatePicker()
    }
    
    @objc func doneButtonAction()
    {

//        self.instanceWhereTextView.resignFirstResponder()
//        self.dateAppliedTextView.resignFirstResponder()
//        self.whatWasEffectTextView.resignFirstResponder()
//        self.whatWentWellTextView.resignFirstResponder()
//        self.whatNotGoesExpectedTextView.resignFirstResponder()
//        self.reflectionTextView.resignFirstResponder()
//        self.doDifferentTextView.resignFirstResponder()
        
        view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0.0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight-self.submitApplicationButton.frame.size.height-60
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
//            print("\n in \(keyboardFrame.cgSizeValue)keyboard hide self frame y :",self.view.frame.origin.y)
        }
    }
    @IBAction func submitApplicationButtonTouch(_ sender: Any) {
        
        self.setCircularboderToTextView()
        
        if instanceWhereTextView.text == "" {
            instanceWhereTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        }else if dateAppliedTextView.text == ""{
            dateAppliedTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        }else if whatWasEffectTextView.text == "" {
            whatWasEffectTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        } else if whatWentWellTextView.text == ""{
            whatWentWellTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        } else if whatNotGoesExpectedTextView.text == ""{
            whatNotGoesExpectedTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        } else if reflectionTextView.text == ""{
            reflectionTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        } else if doDifferentTextView.text == "" {
            doDifferentTextView.circularBorder(color: UIColor.red, width: 2, corner_radius: 6)
            
        }else {
            let alert = UIAlertController(title: "Would you like to submit Application? ", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.submitApplication()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
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
    
    func viewAppAnswers() {
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"topic_id\":\"\(UserDefaults.standard.string(forKey: "applicationTopicID")! as String)\"}" as String
        
        self.parsePostAPIWithParam(apiName: "view_app_answers", paramStr: rawDataStr as NSString){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            if statusVal == "success"{
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    print("\n Success Application Answers fatched: \(ResDictionary)")
                    
                    self.ApplicationDic = (ResDictionary["data"] as! NSArray) as! [Any]
                    let appObj = self.ApplicationDic[0] as! NSDictionary
                    
                    self.instanceWhereTextView.attributedText = self.convertString2AttributedString(rawString: appObj["instance"] as! String)
                    self.dateAppliedTextView.attributedText = self.convertString2AttributedString(rawString:appObj["date_applied"] as! String)
                    self.whatWasEffectTextView.attributedText = self.convertString2AttributedString(rawString:appObj["effect"] as! String)
                    self.whatWentWellTextView.attributedText = self.convertString2AttributedString(rawString:appObj["well"] as! String)
                    self.whatNotGoesExpectedTextView.attributedText = self.convertString2AttributedString(rawString:appObj["unexpected"] as! String)
                    self.reflectionTextView.attributedText = self.convertString2AttributedString(rawString:appObj["reflection"] as! String)
                    self.doDifferentTextView.attributedText = self.convertString2AttributedString(rawString:appObj["different"] as! String)
                    self.scoreLabel.text = "Score: \(appObj["total_marks"] as! String)"
                    
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
    }
    func submitApplication() {
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"topic_id\":\"\(UserDefaults.standard.string(forKey: "applicationTopicID")! as String)\",\"date_applied\":\"\(replaceSpecialSymbols(rawString: dateAppliedTextView.text!))\",\"instance\":\"\(replaceSpecialSymbols(rawString: instanceWhereTextView.text!))\",\"effect\":\"\(replaceSpecialSymbols(rawString: whatWasEffectTextView.text!))\",\"well\":\"\(replaceSpecialSymbols(rawString: whatWentWellTextView.text!))\",\"unexpected\":\"\(replaceSpecialSymbols(rawString: whatNotGoesExpectedTextView.text!))\",\"reflection\":\"\(replaceSpecialSymbols(rawString: reflectionTextView.text!))\",\"different\":\"\(replaceSpecialSymbols(rawString: doDifferentTextView.text!))\",\"app_seen\":\"\(1)\",\"app_attempt\":\"\(1)\"}" as String
        print("\n application param: ",rawDataStr)
        self.parsePostAPIWithParam(apiName: "submit_application", paramStr: rawDataStr as NSString){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            if statusVal == "success"{
                
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    print("\n application submited successfully")
                    
                    let alert = UIAlertController(title: (ResDictionary["message"] as? String)!, message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
        
        print("\n Submit application method call")
    }
    
    func parsePostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {
        var convertedJsonDictResponse:NSDictionary!
        let dataStr: NSString = paramStr
        let postData = NSMutableData(data: dataStr.data(using: String.Encoding.utf8.rawValue)!)
        let r2_URL = "\(Constants.r2_baseURL)\("/")\(apiName)\("/")"
        print("\n r2_URL",r2_URL)
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
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    
    func replaceSpecialSymbols(rawString:String) -> String {
        var finalString = rawString
        finalString = finalString.replacingOccurrences(of: "\\", with: "\\%5C")
        finalString = finalString.replacingOccurrences(of: "&", with: "%26")
        finalString = finalString.replacingOccurrences(of: "\"", with: "\\%22")
        finalString = finalString.replacingOccurrences(of: "+", with: "%2B")
        finalString = finalString.replacingOccurrences(of: ";", with: "%3B")
        finalString = finalString.replacingOccurrences(of: "\n", with: "<br>")
        return finalString
    }
    
    func convertString2AttributedString(rawString:String) -> NSAttributedString {
        
        let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, rawString) as String
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        return attrStr
    }
    func doDatePicker(){
       
        //Create the view
        let inputView = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:240))
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateAppliedTextView.text = dateFormatter.string(from: Date())
        
        let doneButton = UIButton(frame: CGRect(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
        doneButton.setTitle("Done", for: UIControl.State.normal)
        
        doneButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: 18)
        
        doneButton.setTitle("Done", for: UIControl.State.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: UIControl.Event.touchUpInside) // set button click event
       
        dateAppliedTextView.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
        
//        handleDatePicker(sender: datePickerView) // Set the date on start.
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateAppliedTextView.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneButton(sender:UIButton)
    {
        datePickerView.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    // MARK: - Navigation
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
