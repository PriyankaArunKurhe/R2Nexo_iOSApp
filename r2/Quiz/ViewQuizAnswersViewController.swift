//
//  ViewQuizAnswersViewController.swift
//
//
//  Created by NonStop io on 13/01/18.
//

import UIKit
import NVActivityIndicatorView

class ViewQuizAnswersViewController: UIViewController, UITextViewDelegate {
    
    
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
    
    @IBOutlet var totalQuizScoreLabel: UILabel!
    
    
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
        quizEssayTextView.delegate = self
        quizEssayTextView.layer.cornerRadius = 5
        quizEssayTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        quizEssayTextView.layer.borderWidth = 0.5
        quizEssayTextView.clipsToBounds = true
        quizEssayTextView.font =  UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-2))
        quizEssayTextView.isEditable = false
        
        quizID = UserDefaults.standard.string(forKey: "quizeID")! as String
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        self.setBorderToOptionButtons()
        previousNextButtonContainerView.addTopBorderWithColor(color: UIColor.lightGray, width: 2)
        
        quizTitleLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        quetionNumberLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-4))
        questionLabel.font = UIFont(name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        questionTextView.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        optionALable1.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionBLable2.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionCLable3.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        optionDLable4.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        
        totalQuizScoreLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-2))
        
        viewQuizAnswers()
        
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
    
    
    func hideOptionlabels()  {          // hide option label
        optionALable1.isHidden = true
        optionBLable2.isHidden = true
        optionCLable3.isHidden = true
        optionDLable4.isHidden = true
        
        optionAButton1.isHidden = true
        optionBButton2.isHidden = true
        optionCButton3.isHidden = true
        optionDButton4.isHidden = true
    }
    
    
    func showOptionlabels()  {  // show option label
        optionALable1.isHidden = false
        optionBLable2.isHidden = false
        optionCLable3.isHidden = false
        optionDLable4.isHidden = false
        
        optionAButton1.isHidden = false
        optionBButton2.isHidden = false
        optionCButton3.isHidden = false
        optionDButton4.isHidden = false
        
    }
    
    func setBorderToOptionButtons() {  // set border
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


//        self.quizEssayTextView.text = ""
        
//        print("\n self.QuizeQueObj  in set border function ",self.QuizeQueObj)
        
        if self.QuizeQueObj != nil{
            
            if self.QuizeQueObj["student_ans"] as? String != "" {
                let ans = self.QuizeQueObj["student_ans"] as? String
                switch ans {
                case "A"?:
                    print("\n selectedAns = A")
                    self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                    self.optionAButton1.layer.borderWidth = 2
                case "B"?:
                    print("\n selectedAns = B")
                    self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                    self.optionBButton2.layer.borderWidth = 2
                case "C"?:
                    print("\n selectedAns = C")
                    self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                    self.optionCButton3.layer.borderWidth = 2
                case "D"?:
                    print("\n selectedAns = D")
                    self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
                    self.optionDButton4.layer.borderWidth = 2
                default:
                    self.quizEssayTextView.text = self.QuizeQueObj["student_ans"] as? String
                    self.quizEssayTextView.text = self.quizEssayTextView.text.replacingOccurrences(of: "\n", with: "<br>")
                    
                    let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, self.quizEssayTextView.text!) as String
                    let attrStr = try! NSAttributedString(
                        data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                        options:[.documentType: NSAttributedString.DocumentType.html,
                                 .characterEncoding: String.Encoding.utf8.rawValue],
                        documentAttributes: nil)
                    self.quizEssayTextView.attributedText = attrStr
                }
            }
            
            
            if self.QuizeQueObj["correct_ans"] as? String != "" {
                let correctAns = self.QuizeQueObj["correct_ans"] as? String
                switch correctAns {
                case "A"?:
                    print("\n selectedAns = A")
                    self.optionAButton1.layer.borderColor = UIColor.green.cgColor
                    self.optionAButton1.layer.borderWidth = 2
                case "B"?:
                    print("\n selectedAns = B")
                    self.optionBButton2.layer.borderColor = UIColor.green.cgColor
                    self.optionBButton2.layer.borderWidth = 2
                case "C"?:
                    print("\n selectedAns = C")
                    self.optionCButton3.layer.borderColor = UIColor.green.cgColor
                    self.optionCButton3.layer.borderWidth = 2
                case "D"?:
                    print("\n selectedAns = D")
                    self.optionDButton4.layer.borderColor = UIColor.green.cgColor
                    self.optionDButton4.layer.borderWidth = 2
                default:
                    self.quizEssayTextView.text = self.QuizeQueObj["student_ans"] as? String
                    self.quizEssayTextView.text = self.quizEssayTextView.text.replacingOccurrences(of: "\n", with: "<br>")
                    
                    let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, self.quizEssayTextView.text!) as String
                    let attrStr = try! NSAttributedString(
                        data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                        options:[.documentType: NSAttributedString.DocumentType.html,
                                 .characterEncoding: String.Encoding.utf8.rawValue],
                        documentAttributes: nil)
                    self.quizEssayTextView.attributedText = attrStr
                }
            }
            
            if self.QuizeQueObj["question_type"] as? String != "MCQ" {
                self.quizEssayTextView.text = self.QuizeQueObj["student_ans"] as? String
                self.quizEssayTextView.text = self.quizEssayTextView.text.replacingOccurrences(of: "\n", with: "<br>")
                
                let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, self.quizEssayTextView.text!) as String
                let attrStr = try! NSAttributedString(
                    data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                    options:[.documentType: NSAttributedString.DocumentType.html,
                             .characterEncoding: String.Encoding.utf8.rawValue],
                    documentAttributes: nil)
                self.quizEssayTextView.attributedText = attrStr
                
            }
            
            // correct_ans
            
        }
        
    }
    
    
    func viewQuizAnswers()  {   // to get quiz answers
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"quiz_id\": \"\(quizID)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "view_quiz_answers", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.QuizeQuestionListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                
                self.QuizeQueObj = self.QuizeQuestionListDic[self.queIndex] as! NSDictionary
                
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    
//                    var tempQuizeQueObj:NSDictionary!
//                    for i in 0..<self.QuizeQuestionListDic.count {
//                        tempQuizeQueObj = self.QuizeQuestionListDic[i] as! NSDictionary
//                        let intQueID = tempQuizeQueObj["question_id"] as? Int
//                        var questionID = ""
//                        questionID = "\(intQueID!)"
//                        let questionSeen = "1"
//                        let questionAttempt = "0"
//
//                        let dictionary = ["question_id":"\(questionID)",
//                            "answer_text":"",
//                            "seen":"\(questionSeen)",
//                            "attempt":"\(questionAttempt)"]
//                        self.myAnswersArray.insert(dictionary as [String : AnyObject], at: i)
//                    }
//
//                    print("\n answer array befor selecting options: \(self.myAnswersArray)")
                    
                    self.quetionNumberLabel.text = "Question \(self.queIndex+1)/\(self.QuizeQuestionListDic.count)"
                    self.quizTitleLabel.text = ResDictionary["quiz_title"] as? String
                    self.questionLabel.fadeTransition(0.4)
                    self.questionLabel.text = self.QuizeQueObj["question_text"] as? String
                    
                    self.questionTextView.fadeTransition(0.4)
                    self.questionTextView.text = self.QuizeQueObj["question_text"] as? String
                    self.quizHasEssay = (ResDictionary["has_essay"] as? String)!
                    self.totalQuizScoreLabel.text = "Total Score: " + "\((ResDictionary["total_score"] as? String)!)"
                    
//                    print("\n \n has Essay: \(self.quizHasEssay) \(ResDictionary["total_score"] as? String)")
                    
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
                    
                    self.setBorderToOptionButtons()
                    
                    
                    
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
    
    func nextQuestion() {    // to get next question
        
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
               
                
//                self.quizEssayTextView.text = ""
//                var tempQuizeQueObj:NSDictionary!
//                tempQuizeQueObj = self.myAnswersArray[self.queIndex] as NSDictionary
//                if tempQuizeQueObj["answer_text"] as? String != "" {
//                    let ans = tempQuizeQueObj["answer_text"] as? String
//                    switch ans {
//                    case "A"?:
//                        print("\n selectedAns = A")
//                        self.setBorderToOptionButtons()
//                        self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionAButton1.layer.borderWidth = 2
//                    case "B"?:
//                        print("\n selectedAns = B")
//                        self.setBorderToOptionButtons()
//                        self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionBButton2.layer.borderWidth = 2
//                    case "C"?:
//                        print("\n selectedAns = C")
//                        self.setBorderToOptionButtons()
//                        self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionCButton3.layer.borderWidth = 2
//                    case "D"?:
//                        print("\n selectedAns = D")
//                        self.setBorderToOptionButtons()
//                        self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionDButton4.layer.borderWidth = 2
//                    default:
//                        self.quizEssayTextView.text = ans
//                    }
//                }
//
                
                
            }
        }
    }
    
    
    @IBAction func previousQuestionButtonTouch(_ sender: Any) {
        
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
                
//
//                
//                self.quizEssayTextView.text = ""
//                var tempQuizeQueObj:NSDictionary!
//                tempQuizeQueObj = self.myAnswersArray[self.queIndex] as NSDictionary
//                if tempQuizeQueObj["answer_text"] as? String != "" {
//                    let ans = tempQuizeQueObj["answer_text"] as? String
//                    switch ans {
//                    case "A"?:
//                        print("\n selectedAns = A")
//                        self.setBorderToOptionButtons()
//                        self.optionAButton1.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionAButton1.layer.borderWidth = 2
//                    case "B"?:
//                        print("\n selectedAns = B")
//                        self.setBorderToOptionButtons()
//                        self.optionBButton2.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionBButton2.layer.borderWidth = 2
//                    case "C"?:
//                        print("\n selectedAns = C")
//                        self.setBorderToOptionButtons()
//                        self.optionCButton3.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionCButton3.layer.borderWidth = 2
//                    case "D"?:
//                        print("\n selectedAns = D")
//                        self.setBorderToOptionButtons()
//                        self.optionDButton4.layer.borderColor = UIColor.r2_Nav_Bar_Color.cgColor
//                        self.optionDButton4.layer.borderWidth = 2
//                    default:
//                        self.quizEssayTextView.text = ans
//                    }
//                }
                
            }
        }
        
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
    
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: true, completion: nil)
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

