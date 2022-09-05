//
//  StartQuizViewController.swift
//  r2
//
//  Created by NonStop io on 04/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class StartQuizViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet var optionALable1: UILabel!
    @IBOutlet var optionBLable2: UILabel!
    @IBOutlet var optionCLable3: UILabel!
    @IBOutlet var optionDLable4: UILabel!
    
    @IBOutlet var optionAButton1: UIButton!
    @IBOutlet var optionBButton2: UIButton!
    @IBOutlet var optionCButton3: UIButton!
    @IBOutlet var optionDButton4: UIButton!
    
    @IBOutlet var previousNextButtonContainerView: UIView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var questionTextView: UITextView!
    
    
    @IBOutlet var quizTitleLabel: UILabel!
    @IBOutlet var quetionNumberLabel: UILabel!
    
    @IBOutlet var quizEssayTextView: UITextView!
    
    @IBOutlet var essayConatinerView: UIView!
    
    @IBOutlet var submitQuizButton: UIButton!
    
    var QuizeQuestionListDic:[Any] = []
    var QuizAnswersDic:[Any] = []
    var myAnswersArray = [[String: AnyObject]]()
    var arrayOfDictionaries: [[String:AnyObject]]!
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    
    var quizID = ""
    var queIndex = 0
    var QuizeQueObj:NSDictionary!
    var quizHasEssay = "False"
    var essayStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.addDoneButtonOnKeyboard()
        quizEssayTextView.delegate = self
        
        quizEssayTextView.layer.cornerRadius = 5
        quizEssayTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        quizEssayTextView.layer.borderWidth = 0.5
        quizEssayTextView.clipsToBounds = true
        quizEssayTextView.font =  UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-2))
        
        quizID = UserDefaults.standard.string(forKey: "quizeID")! as String
        
        submitQuizButton.titleLabel?.font =  UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-2))
        submitQuizButton.backgroundColor = UIColor.r2_Nav_Bar_Color
        submitQuizButton.layer.cornerRadius = 4
        submitQuizButton.layer.borderWidth = 0.5
        submitQuizButton.layer.borderColor = UIColor.lightGray.cgColor
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        self.setBorderToOptionButtons()
        previousNextButtonContainerView.addTopBorderWithColor(color: UIColor.lightGray, width: 2)
        
        quizTitleLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size-2))
        quetionNumberLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-4))
        
        questionTextView.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size+2))
        
        questionLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        optionALable1.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionBLable2.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionCLable3.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionDLable4.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        
        getQuizeQuestionList()
        
        //        self.questionBackgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "quiz_curve_bk")!)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.activityProgress.removeFromSuperview()
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
        self.quizEssayTextView.inputAccessoryView = doneToolbar
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
        
        if textView.text == "Start typing here.." {
            textView.text = ""
        }
        textView.textColor = UIColor.black
    }
    
    @objc func doneButtonAction()
    {
        self.quizEssayTextView.resignFirstResponder()
        
        if quizEssayTextView.text != "Start typing here.." && quizEssayTextView.text != "" {
            
            self.addEssayAnsToAnsArray(essayIndex: self.queIndex, essayQuestionId: (self.QuizeQueObj["question_id"] as? Int)!)
        }
        
        
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0.0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight - self.previousNextButtonContainerView.frame.size.height
            }
            print("\n self frame y :",self.view.frame.origin.y)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
            print("\n in \(keyboardFrame.cgSizeValue)keyboard hide self frame y :",self.view.frame.origin.y)
        }
    }
    
    func hideOptionlabels()  {         //  hide options label
        optionALable1.isHidden = true
        optionBLable2.isHidden = true
        optionCLable3.isHidden = true
        optionDLable4.isHidden = true
        
        optionAButton1.isHidden = true
        optionBButton2.isHidden = true
        optionCButton3.isHidden = true
        optionDButton4.isHidden = true
    }
    
    
    func showOptionlabels()  {      // show option label
        optionALable1.isHidden = false
        optionBLable2.isHidden = false
        optionCLable3.isHidden = false
        optionDLable4.isHidden = false
        
        optionAButton1.isHidden = false
        optionBButton2.isHidden = false
        optionCButton3.isHidden = false
        optionDButton4.isHidden = false
        
    }
    
    func setBorderToOptionButtons() {   // set border to button
        optionAButton1.backgroundColor = .clear
        optionAButton1.layer.cornerRadius = 7
        optionAButton1.layer.borderWidth = 1
        optionAButton1.layer.borderColor = UIColor.r2_faintGray.cgColor
        
        optionBButton2.backgroundColor = .clear
        optionBButton2.layer.cornerRadius = 7
        optionBButton2.layer.borderWidth = 1
        optionBButton2.layer.borderColor = UIColor.r2_faintGray.cgColor
        
        optionCButton3.backgroundColor = .clear
        optionCButton3.layer.cornerRadius = 7
        optionCButton3.layer.borderWidth = 1
        optionCButton3.layer.borderColor = UIColor.r2_faintGray.cgColor
        
        optionDButton4.backgroundColor = .clear
        optionDButton4.layer.cornerRadius = 7
        optionDButton4.layer.borderWidth = 1
        optionDButton4.layer.borderColor = UIColor.r2_faintGray.cgColor
    }
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Select Option button
    
    @IBAction func optionAButton1Touch(_ sender: Any) {
        self.setBorderToOptionButtons()
        self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
        self.optionAButton1.layer.borderWidth = 2
        
        self.addSelectedAnsToAnsArray(optionnumber: 1)
    }
    
    
    @IBAction func optionBButton2Touch(_ sender: Any) {
        self.setBorderToOptionButtons()
        self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
        self.optionBButton2.layer.borderWidth = 2
        
        self.addSelectedAnsToAnsArray(optionnumber: 2)
    }
    
    @IBAction func optionCButton3Touch(_ sender: Any) {
        self.setBorderToOptionButtons()
        self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
        self.optionCButton3.layer.borderWidth = 2
        
        self.addSelectedAnsToAnsArray(optionnumber: 3)
    }
    
    @IBAction func optionDButton4Touch(_ sender: Any) {
        self.setBorderToOptionButtons()
        self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
        self.optionDButton4.layer.borderWidth = 2
        
        self.addSelectedAnsToAnsArray(optionnumber: 4)
    }
    
    
    func addSelectedAnsToAnsArray(optionnumber:Int) {   // select ans and add to array
        var selectedAns = ""
        switch optionnumber {
        case 1:
            selectedAns = "A"
        case 2:
            selectedAns = "B"
        case 3:
            selectedAns = "C"
        case 4:
            selectedAns = "D"
        case 5:
            selectedAns = (self.QuizeQueObj["op_a"] as? String)!
        default:
            selectedAns = ""
        }
        
        let intQueID = self.QuizeQueObj["question_id"] as? Int
        var questionID = ""
        questionID = "\(intQueID!)"
        let questionSeen = "1"
        let questionAttempt = "1"
        print("\n \n selected answer details \(selectedAns) , \(questionID), \(questionSeen) , \(questionAttempt)")
        let dictionary = ["question_id":"\(questionID)",
                          "answer_text":"\(selectedAns)",
                          "seen":"\(questionSeen)",
                          "attempt":"\(questionAttempt)"]
        
        //        myAnswersArray.insert(dictionary as [String : AnyObject], at: queIndex)
        
        myAnswersArray[queIndex] = (dictionary as [String : AnyObject])
        
        print("\n answer dic: \(myAnswersArray as AnyObject)")
    }
    
    
    func addEssayAnsToAnsArray(essayIndex:Int,essayQuestionId:Int) {   // to add essay
        var selectedAns = ""
        
        let essayText = self.quizEssayTextView.text
        self.essayStr = essayText!
        self.essayStr = self.essayStr.replacingOccurrences(of: "\\", with: "\\%5C")
        self.essayStr = self.essayStr.replacingOccurrences(of: "&", with: "%26")
        self.essayStr = self.essayStr.replacingOccurrences(of: "\"", with: "\\%22")
        self.essayStr = self.essayStr.replacingOccurrences(of: "+", with: "%2B")
        self.essayStr = self.essayStr.replacingOccurrences(of: ";", with: "%3B")
        self.essayStr = self.essayStr.replacingOccurrences(of: "\n", with: "<br>")
        
        selectedAns = self.essayStr
        
        let intQueID = essayQuestionId
        var questionID = ""
        questionID = "\(intQueID)"
        let questionSeen = "1"
        let questionAttempt = "1"
        print("\n \n selected answer details \(selectedAns) , \(questionID), \(questionSeen) , \(questionAttempt)")
        let dictionary = ["question_id":"\(questionID)",
                          "answer_text":"\(selectedAns)",
                          "seen":"\(questionSeen)",
                          "attempt":"\(questionAttempt)"]
        myAnswersArray[essayIndex] = (dictionary as [String : AnyObject])
        
        print("\n answer dic after essay added : \(myAnswersArray as AnyObject)")
    }
    
    
    
    
    func getQuizeQuestionList()  {      // to get all questions of quiz by id
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"quiz_id\": \"\(quizID)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_quiz_questions", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.QuizeQuestionListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                
                self.QuizeQueObj = self.QuizeQuestionListDic[self.queIndex] as! NSDictionary
                
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    
                    var tempQuizeQueObj:NSDictionary!
                    for i in 0..<self.QuizeQuestionListDic.count {
                        tempQuizeQueObj = self.QuizeQuestionListDic[i] as! NSDictionary
                        let intQueID = tempQuizeQueObj["question_id"] as? Int
                        var questionID = ""
                        questionID = "\(intQueID!)"
                        let questionSeen = "1"
                        let questionAttempt = "0"
                        
                        let dictionary = ["question_id":"\(questionID)",
                                          "answer_text":"",
                                          "seen":"\(questionSeen)",
                                          "attempt":"\(questionAttempt)"]
                        self.myAnswersArray.insert(dictionary as [String : AnyObject], at: i)
                    }
                    
                    print("\n answer array befor selecting options: \(self.myAnswersArray)")
                    
                    self.quetionNumberLabel.text = "Question \(self.queIndex+1)/\(self.QuizeQuestionListDic.count)"
                    self.quizTitleLabel.text = ResDictionary["quiz_title"] as? String
                    self.questionLabel.fadeTransition(0.4)
                    self.questionLabel.text = self.QuizeQueObj["question_text"] as? String
                    self.questionTextView.fadeTransition(0.4)
                    self.questionTextView.text = self.QuizeQueObj["question_text"] as? String
                    
                    self.quizHasEssay = (ResDictionary["has_essay"] as? String)!
                    print("\n \n has Essay: \(self.quizHasEssay) ")
                    
                    if self.QuizeQueObj["question_type"] as? String == "MCQ" {
                        self.showOptionlabels()
                        self.essayConatinerView.isHidden = true
                        self.optionALable1.text = self.QuizeQueObj["op_a"] as? String
                        self.optionBLable2.text = self.QuizeQueObj["op_b"] as? String
                        self.optionCLable3.text = self.QuizeQueObj["op_c"] as? String
                        self.optionDLable4.text = self.QuizeQueObj["op_d"] as? String
                    }else{
                        
                        self.hideOptionlabels()
                        self.essayConatinerView.isHidden = false
                        self.essayConatinerView.fadeTransition(0.4)
                    }
                    
                    if self.queIndex+1 == self.QuizeQuestionListDic.count {
                        self.submitQuizButton.isHidden = false
                    }else{
                        self.submitQuizButton.isHidden = true
                    }
                    
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
    }
    
    
    @IBAction func nextQuestionButtonTouch(_ sender: Any) {
        
        print("\n \n que index \(self.queIndex), quiz qution count \(self.QuizeQuestionListDic.count) ")
        self.nextQuestion()
        
    }
    
    func nextQuestion() {  // for next question
        
        if  self.queIndex != self.QuizeQuestionListDic.count - 1 {
            self.queIndex = self.queIndex + 1
            self.QuizeQueObj = self.QuizeQuestionListDic[self.queIndex] as! NSDictionary
            
            DispatchQueue.main.async {
                self.setBorderToOptionButtons()
                self.quetionNumberLabel.text = "Question \(self.queIndex+1)/\(self.QuizeQuestionListDic.count)"
                
                self.questionLabel.fadeTransition(0.4)
                self.questionLabel.text = self.QuizeQueObj["question_text"] as? String
                self.questionTextView.fadeTransition(0.4)
                self.questionTextView.text = self.QuizeQueObj["question_text"] as? String
                if self.QuizeQueObj["question_type"] as? String == "MCQ" {
                    self.showOptionlabels()
                    self.essayConatinerView.isHidden = true
                    self.optionALable1.text = self.QuizeQueObj["op_a"] as? String
                    self.optionBLable2.text = self.QuizeQueObj["op_b"] as? String
                    self.optionCLable3.text = self.QuizeQueObj["op_c"] as? String
                    self.optionDLable4.text = self.QuizeQueObj["op_d"] as? String
                }else{
                    self.essayConatinerView.isHidden = false
                    self.essayConatinerView.fadeTransition(0.4)
                    self.hideOptionlabels()
                    //                    self.addSelectedAnsToAnsArray(optionnumber: 5 )
                }
                
                if self.queIndex+1 == self.QuizeQuestionListDic.count {
                    self.submitQuizButton.isHidden = false
                }else{
                    self.submitQuizButton.isHidden = true
                }
                
                self.quizEssayTextView.text = ""
                var tempQuizeQueObj:NSDictionary!
                tempQuizeQueObj = self.myAnswersArray[self.queIndex] as NSDictionary
                if tempQuizeQueObj["answer_text"] as? String != "" {
                    let ans = tempQuizeQueObj["answer_text"] as? String
                    switch ans {
                    case "A"?:
                        print("\n selectedAns = A")
                        self.setBorderToOptionButtons()
                        self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionAButton1.layer.borderWidth = 2
                    case "B"?:
                        print("\n selectedAns = B")
                        self.setBorderToOptionButtons()
                        self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionBButton2.layer.borderWidth = 2
                    case "C"?:
                        print("\n selectedAns = C")
                        self.setBorderToOptionButtons()
                        self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionCButton3.layer.borderWidth = 2
                    case "D"?:
                        print("\n selectedAns = D")
                        self.setBorderToOptionButtons()
                        self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionDButton4.layer.borderWidth = 2
                    default:
                        self.quizEssayTextView.text = ans
                    }
                }
                
                
                
            }
        }
    }
    
    
    @IBAction func previousQuestionButtonTouch(_ sender: Any) {  // for previous question
        
        print("\n \n que index \(self.queIndex), quiz qution count \(self.QuizeQuestionListDic.count) ")
        
        if self.queIndex != 0 {
            self.queIndex = self.queIndex - 1
            self.QuizeQueObj = self.QuizeQuestionListDic[self.queIndex] as! NSDictionary
            
            DispatchQueue.main.async {
                self.setBorderToOptionButtons()
                self.quetionNumberLabel.text = "Question \(self.queIndex+1)/\(self.QuizeQuestionListDic.count)"
                self.questionLabel.fadeTransition(0.4)
                self.questionLabel.text = self.QuizeQueObj["question_text"] as? String
                self.questionTextView.fadeTransition(0.4)
                self.questionTextView.text = self.QuizeQueObj["question_text"] as? String
                
                if self.QuizeQueObj["question_type"] as? String == "MCQ" {
                    self.essayConatinerView.isHidden = true
                    self.showOptionlabels()
                    self.optionALable1.text = self.QuizeQueObj["op_a"] as? String
                    self.optionBLable2.text = self.QuizeQueObj["op_b"] as? String
                    self.optionCLable3.text = self.QuizeQueObj["op_c"] as? String
                    self.optionDLable4.text = self.QuizeQueObj["op_d"] as? String
                }else{
                    self.essayConatinerView.isHidden = false
                    self.essayConatinerView.fadeTransition(0.4)
                    self.hideOptionlabels()
                }
                
                if self.queIndex+1 == self.QuizeQuestionListDic.count {
                    self.submitQuizButton.isHidden = false
                }else{
                    self.submitQuizButton.isHidden = true
                }
                
                self.quizEssayTextView.text = ""
                var tempQuizeQueObj:NSDictionary!
                tempQuizeQueObj = self.myAnswersArray[self.queIndex] as NSDictionary
                if tempQuizeQueObj["answer_text"] as? String != "" {
                    let ans = tempQuizeQueObj["answer_text"] as? String
                    switch ans {
                    case "A"?:
                        print("\n selectedAns = A")
                        self.setBorderToOptionButtons()
                        self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionAButton1.layer.borderWidth = 2
                    case "B"?:
                        print("\n selectedAns = B")
                        self.setBorderToOptionButtons()
                        self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionBButton2.layer.borderWidth = 2
                    case "C"?:
                        print("\n selectedAns = C")
                        self.setBorderToOptionButtons()
                        self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionCButton3.layer.borderWidth = 2
                    case "D"?:
                        print("\n selectedAns = D")
                        self.setBorderToOptionButtons()
                        self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                        self.optionDButton4.layer.borderWidth = 2
                    default:
                        self.quizEssayTextView.text = ans
                    }
                }
                
            }
        }
        
    }
    
    
    @IBAction func submitQuizButtonTouch(_ sender: Any) {
        
        let alert = UIAlertController(title: "Would you like to submit your Answers? ", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.submitAnswers()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Submit Quiz
    
    func submitAnswers() {   // to submit quiz with ans
        
        //            DispatchQueue.main.async {
        //                if self.queIndex+1 == self.QuizeQuestionListDic.count && self.quizHasEssay == "True" && self.QuizeQueObj["question_type"] as? String == "Essay"{
        //                    self.addSelectedAnsToAnsArray(optionnumber: 5)
        //                }
        //            }
        //
        //        let when = DispatchTime.now() + 3
        //        DispatchQueue.main.asyncAfter(deadline: when) {
        
        let rawDataStr: String = "data={\"email\":\"\(self.userName)\",\"password\":\"\(self.userPassword)\",\"quiz_rating\":\"\(4)\",\"quiz_id\": \"\(self.quizID)\",\"answers\":\(self.myAnswersArray.toJSONString())}" as String
        
        print("\n Submit Quiz param: ",rawDataStr)
        
        self.PostAPIWithParam(apiName: "submit_quiz", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            print("\n response from Quiz: ",(ResDictionary["message"] as? String)!)
            DispatchQueue.main.async {
                if statusVal == "success"{
                    self.quizEssayTextView.text = "Start typing here.."
                    self.quizEssayTextView.textColor = UIColor.lightGray
                    self.quizEssayTextView.endEditing(true)
                    
                    let alert = UIAlertController(title: (ResDictionary["message"] as? String)!, message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
        
        //        }
        
        
        
    }
    
    
    func PostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {
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
                        print("\n \n response data convertedJsonDictResponse",convertedJsonDictResponse)
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
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


extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
