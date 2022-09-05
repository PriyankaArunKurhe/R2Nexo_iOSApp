//
//  QuizViewController.swift
//  r2
//
//  Created by NonStop io on 14/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class QuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var listHeddingLabel: UILabel!
    @IBOutlet var quizSelectedBottomBorderLable: UILabel!
    @IBOutlet var quizButton: UIButton!
    @IBOutlet var assigSelectedBottomBorderLable: UILabel!
    @IBOutlet var assignmentButton: UIButton!
    
    var isQuizListTable = true
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    let refreshControl = UIRefreshControl()
    
    var QuizeListDic:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listHeddingLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))    
        
        listHeddingLabel.addTopBorderWithColor(color: UIColor.r2_faintGray, width: 2)
        tableView.addTopBorderWithColor(color: UIColor.r2_faintGray, width: 2)
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        quizButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        
        assignmentButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextScreen))
        leftGesture.direction = .left
        self.view.addGestureRecognizer(leftGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBackScreen))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        //        if UserDefaults.standard.bool(forKey: "isQuizList") != nil {
        //            isQuizListTable = UserDefaults.standard.bool(forKey: "isQuizList") as Bool
        //        }else{
        //
        //        }
        
        isQuizListTable = UserDefaults.standard.bool(forKey: "isQuizList") as Bool
        
        if isQuizListTable {
            self.getQuizeList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            assigSelectedBottomBorderLable.backgroundColor = UIColor.clear
            listHeddingLabel.text = "Your Quizzes are listed below!"
        }else{
            self.getAssignmentList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.clear
            assigSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            listHeddingLabel.text = "Your Assignments are listed below!"
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        
        print("\n \n print tab isquiz: \(UserDefaults.standard.bool(forKey: "isQuizList"))")
        
        isQuizListTable = UserDefaults.standard.bool(forKey: "isQuizList") as Bool
        
        
        if isQuizListTable {
            self.getQuizeList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            assigSelectedBottomBorderLable.backgroundColor = UIColor.clear
            listHeddingLabel.text = "Your Quizzes are listed below!"
        }else{
            self.getAssignmentList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.clear
            assigSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            listHeddingLabel.text = "Your Assignments are listed below!"
        }
        
        //        self.circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        //        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseOut, animations: {
        //            self.circleView.transform = .identity
        //            self.circleView.backgroundColor = UIColor.black
        //
        //        }, completion: {(isCompleted) in
        //
        //            UIView.animate(withDuration: 4, animations: {
        //                self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        //            }, completion: {(isCompleted) in
        ////                        let circleWidth = self.circleView.frame.size.width
        ////                        let circleHeight = circleWidth
        ////                        let circleView = CircleClosing(frame: CGRect(x: self.circleView.frame.origin.x-2.5, y: self.circleView.frame.origin.y-2.5, width: circleWidth+5, height: circleHeight+5))
        ////                        self.view.addSubview(circleView)
        ////                        circleView.animateCircle(duration: 3.0)
        //
        //            })
        //
        //        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func swipeToNextScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 3
    }
    @objc func swipeToBackScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 1
    }
    
    @objc func refresh(){
        //        self.getQuizeList()
        //        refreshControl.endRefreshing()
        
        if isQuizListTable {
            self.getQuizeList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            assigSelectedBottomBorderLable.backgroundColor = UIColor.clear
            listHeddingLabel.text = "Your Quizzes are listed below!"
        }else{
            self.getAssignmentList()
            quizSelectedBottomBorderLable.backgroundColor = UIColor.clear
            assigSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
            listHeddingLabel.text = "Your Assignments are listed below!"
        }
        refreshControl.endRefreshing()
    }
    
    func getAssignmentList()  {
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n get student assign list param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_student_assign_list", paramStr: rawDataStr as NSString){  ResDictionary in
            //            print("\n Assignment Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.QuizeListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    self.tableView.reloadData()
                    //                    print("\n \n ## QuizeList List \(self.QuizeListDic as! [Any])")
                    if self.QuizeListDic.count < 1 {
                        self.listHeddingLabel.text = "No Assignments Found For You"
                    }
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
        
    }
    
    
    @IBAction func quizButtonTouch(_ sender: Any) {
        
        print("\n Quiz button Touch")
        UserDefaults.standard.set(true, forKey: "isQuizList")
        isQuizListTable = true
        quizSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
        assigSelectedBottomBorderLable.backgroundColor = UIColor.clear
        listHeddingLabel.text = "Your Quizzes are listed below!"
        self.getQuizeList()
        
    }
    
    
    
    @IBAction func AssignmentButtonTouch(_ sender: Any) {
        print("\n Assignment button Touch")
        UserDefaults.standard.set(false, forKey: "isQuizList")
        isQuizListTable = false
        quizSelectedBottomBorderLable.backgroundColor = UIColor.clear
        assigSelectedBottomBorderLable.backgroundColor = UIColor.r2_Nav_Bar_Color
        listHeddingLabel.text = "Your Assignments are listed below!"
        self.getAssignmentList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.QuizeListDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizeListCell", for: indexPath) as! QuizeListTableViewCell
        let QuizeObj = QuizeListDic[indexPath.row] as! NSDictionary
        
        if isQuizListTable {
            // quiz table
            
            cell.quizeTitleLbl.text = QuizeObj["quiz_desc"] as? String
            cell.quizeCreatedTimeLbl.text = QuizeObj["quiz_created_at"] as? String
            cell.quizeNumberLbl.text = "\(indexPath.row+1)"
            cell.quizStatusButton.setTitle("", for: .normal)
            cell.quizViewAnswersButton.setTitle("", for: .normal)
            cell.quizScoreLabel.text = ""
            
            if QuizeObj["quiz_status"] as? String == "take_now" {
                //                cell.quizStatusButton.backgroundColor = UIColor.red  rgb(74,144,226)
                cell.quizStatusButton.backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Take Now", for: .normal)
                cell.quizStatusButton.isEnabled = true
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if QuizeObj["quiz_status"] as? String == "pending_review" {
                cell.quizStatusButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Reviewing", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if QuizeObj["quiz_status"] as? String == "submitted" {
                //rgb(109,189,16)
                cell.quizStatusButton.backgroundColor = UIColor(red: 109.0/255.0, green: 189.0/255.0, blue: 16.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Submitted", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = false
                cell.quizViewAnswersButton.setTitle("View Answers", for: .normal)
                var score = ""
                score = (QuizeObj["score"] as? String)!
                cell.quizScoreLabel.text = "You have scored \(score) points in this quiz"
                let string = "You have scored \(score) points in this quiz" as NSString
                let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
                let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
                attributedString.addAttributes(boldFontAttribute, range: string.range(of: score))
                cell.quizScoreLabel.attributedText = attributedString
            }
            
            cell.quizStatusButton.tag = 0
            cell.quizStatusButton.accessibilityHint = QuizeObj["quiz_id"] as? String
            cell.quizStatusButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizStatusButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            cell.quizViewAnswersButton.tag = 1
            cell.quizViewAnswersButton.accessibilityHint = QuizeObj["quiz_id"] as? String
            cell.quizViewAnswersButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizViewAnswersButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
        }else {
            // assignment table
            cell.quizeTitleLbl.text = QuizeObj["title"] as? String
            cell.quizeCreatedTimeLbl.text = QuizeObj["created_at"] as? String
            cell.quizeNumberLbl.text = "\(indexPath.row+1)"
            cell.quizStatusButton.setTitle("", for: .normal)
            cell.quizViewAnswersButton.setTitle("", for: .normal)
            cell.quizScoreLabel.text = ""
            
            if QuizeObj["status"] as? String == "take_now" {
                //                cell.quizStatusButton.backgroundColor = UIColor.red
                cell.quizStatusButton.backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Take Now", for: .normal)
                cell.quizStatusButton.isEnabled = true
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if QuizeObj["status"] as? String == "pending_review" {
                // rgb(245,166,35)
                cell.quizStatusButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Reviewing", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if QuizeObj["status"] as? String == "submitted" {
                cell.quizStatusButton.backgroundColor = UIColor(red: 109.0/255.0, green: 189.0/255.0, blue: 16.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Submitted", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = false
                cell.quizViewAnswersButton.setTitle("View Answers", for: .normal)
                var score = ""
                score = (QuizeObj["score"] as? String)!
                cell.quizScoreLabel.text = "You have scored \(score) points in this assignment"
                let string = "You have scored \(score) points in this assignment" as NSString
                let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
                let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
                attributedString.addAttributes(boldFontAttribute, range: string.range(of: score))
                cell.quizScoreLabel.attributedText = attributedString
            }
            
            cell.quizStatusButton.tag = 0
            cell.quizStatusButton.accessibilityHint = QuizeObj["assign_id"] as? String
            cell.quizStatusButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizStatusButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            cell.quizViewAnswersButton.tag = 1
            cell.quizViewAnswersButton.accessibilityHint = QuizeObj["assign_id"] as? String
            cell.quizViewAnswersButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizViewAnswersButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
        }
        
        //        if(cell.isSelected){
        //            cell.backgroundColor = UIColor.r2_Nav_Bar_Color
        //        }else{
        //            cell.backgroundColor = UIColor.clear
        //        }
        
        //        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let QuizeObj = QuizeListDic[indexPath.row] as! NSDictionary
        //
        //        if isQuizListTable {
        //            let quizeID : String = QuizeObj["quiz_id"] as! String
        //            let stringQuizeID = "\(quizeID)"
        //            print(stringQuizeID)
        //            UserDefaults.standard.set(stringQuizeID, forKey: "quizeID")
        //            if QuizeObj["quiz_status"] as? String == "take_now" {
        //                self.performSegue(withIdentifier: "QuizListToStartQuizViewSegue", sender: self)
        //            }
        //        }else {
        //            print("\n Go to Assignment View quizAssignmentToStartAssignmentViewCtrlrSegue")
        //            let assignmentID : String = QuizeObj["assign_id"] as! String
        //            let stringassignmentID = "\(assignmentID)"
        //            print(stringassignmentID)
        //            UserDefaults.standard.set(stringassignmentID, forKey: "assignmentID")
        //
        //            if QuizeObj["status"] as? String == "take_now" {
        //                self.performSegue(withIdentifier: "quizAssignToStartAssigntViewCtrlrSegue", sender: self)
        //            }
        //
        //        }
    }
    
    
    
    
    
    // MARK: - Navigation
    
    @objc func cellButtonTouchAction(_ sender: UIButton){
        
        print("\n Sender hint For Like button: \(String(describing: sender.accessibilityHint))")
        let quizIndex = Int(sender.accessibilityIdentifier!)
        let QuizeObj = self.QuizeListDic[quizIndex!] as! NSDictionary
        
        DispatchQueue.main.async {
            if(sender.tag == 0) {
                // Start quiz/Assignment
                if self.isQuizListTable {
                    
                    if QuizeObj["quiz_id"] as? String != nil {
                        let quizeID : String = QuizeObj["quiz_id"] as! String
                        let stringQuizeID = "\(quizeID)"
                        print(stringQuizeID)
                        UserDefaults.standard.set(stringQuizeID, forKey: "quizeID")
                        if QuizeObj["quiz_status"] as? String == "take_now" {
                            self.performSegue(withIdentifier: "QuizListToStartQuizViewSegue", sender: self)
                        }
                    }
                    
                }else {
                    print("\n Go to Assignment View quizAssignmentToStartAssignmentViewCtrlrSegue")
                    let assignmentID : String = QuizeObj["assign_id"] as! String
                    let stringassignmentID = "\(assignmentID)"
                    print(stringassignmentID)
                    UserDefaults.standard.set(stringassignmentID, forKey: "assignmentID")
                    
                    if QuizeObj["status"] as? String == "take_now" {
                        self.performSegue(withIdentifier: "quizAssignToStartAssigntViewCtrlrSegue", sender: self)
                        UserDefaults.standard.set("true", forKey: "isEditable")
                    }
                }
                
            }else if(sender.tag == 1) {
                // view quiz/Assignment answers
                if self.isQuizListTable {
                    if QuizeObj["quiz_id"] as? String != nil {
                        let quizeID : String = QuizeObj["quiz_id"] as! String
                        let stringQuizeID = "\(quizeID)"
                        print(stringQuizeID)
                        UserDefaults.standard.set(stringQuizeID, forKey: "quizeID")
                        if QuizeObj["quiz_status"] as? String == "submitted" {
                            self.performSegue(withIdentifier: "fromQuizListToQuizViewAnsAegue", sender: self)
                        }
                    }
                }else {
                    print("\n Go to Assignment View for submitted Answer")
                    let assignmentID : String = QuizeObj["assign_id"] as! String
                    let stringassignmentID = "\(assignmentID)"
                    print(stringassignmentID)
                    UserDefaults.standard.set(stringassignmentID, forKey: "assignmentID")
                    
                    
                    if QuizeObj["status"] as? String == "submitted" {
                        UserDefaults.standard.set("false", forKey: "isEditable")
                        self.performSegue(withIdentifier: "quizAssignToStartAssigntViewCtrlrSegue", sender: self)
                    }
                }
                
            }
            
        }
        
    }
    
    
    func getQuizeList()  {
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_student_quiz_list", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.QuizeListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    self.tableView.reloadData()
                    //                    print("\n \n ## QuizeList List \(self.QuizeListDic as! [Any])")
                    if self.QuizeListDic.count < 1 {
                        self.listHeddingLabel.text = "No Quizzes Found For You"
                    }
                }
            }else{
                
                DispatchQueue.main.async {
                    self.listHeddingLabel.text = "No Quizzes Found For You"
                    self.QuizeListDic.removeAll()
                    self.tableView.reloadData()
                }
                self.showToast(message: (ResDictionary["message"] as? String)!)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
