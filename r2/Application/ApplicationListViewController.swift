//
//  ApplicationListViewController.swift
//  r2
//
//  Created by NonStop io on 15/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ApplicationListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var listHeddingLabel: UILabel!
    
    
    var ApplicationListDic:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        self.getApplicationList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getApplicationList()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    
    @objc func swipeToBack(sender:UISwipeGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @objc func refresh(){
        print("\n\n Refresh func call \n \n")
        self.getApplicationList()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ApplicationListDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicationListCell", for: indexPath) as! QuizeListTableViewCell

        
        let ApplicationObj = ApplicationListDic[indexPath.row] as! NSDictionary
            
            cell.quizeTitleLbl.text = ApplicationObj["title"] as? String
            cell.quizeCreatedTimeLbl.text = ApplicationObj["created_at"] as? String
            cell.quizeNumberLbl.text = "\(indexPath.row+1)"
            cell.quizStatusButton.setTitle("", for: .normal)
            cell.quizViewAnswersButton.setTitle("", for: .normal)
            cell.quizScoreLabel.text = ""
            
            if ApplicationObj["status"] as? String == "take_now" {
                //                cell.quizStatusButton.backgroundColor = UIColor.red
                cell.quizStatusButton.backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Take Now", for: .normal)
                cell.quizStatusButton.isEnabled = true
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if ApplicationObj["status"] as? String == "pending_review" {
                cell.quizStatusButton.backgroundColor = UIColor(red: 245.0/255.0, green: 166.0/255.0, blue: 35.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Reviewing", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = true
                cell.quizScoreLabel.text = ""
            }else if ApplicationObj["status"] as? String == "submitted" {
                cell.quizStatusButton.backgroundColor = UIColor(red: 109.0/255.0, green: 189.0/255.0, blue: 16.0/255.0, alpha: 0.99)
                cell.quizStatusButton.setTitle("Submitted", for: .normal)
                cell.quizStatusButton.isEnabled = false
                cell.quizViewAnswersButton.isHidden = false
                cell.quizViewAnswersButton.setTitle("View Answers", for: .normal)
                var score = ""
                score = (ApplicationObj["score"] as? String)!
                cell.quizScoreLabel.text = "You have scored \(score) points in this."
                let string = "You have scored \(score) points in this Application" as NSString
                let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.0)])
                let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
                attributedString.addAttributes(boldFontAttribute, range: string.range(of: score))
                cell.quizScoreLabel.attributedText = attributedString
            }
            
            cell.quizStatusButton.tag = 0
            cell.quizStatusButton.accessibilityHint = ApplicationObj["topic_id"] as? String
            cell.quizStatusButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizStatusButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            cell.quizViewAnswersButton.tag = 1
            cell.quizViewAnswersButton.accessibilityHint = ApplicationObj["topic_id"] as? String
            cell.quizViewAnswersButton.accessibilityIdentifier = String(indexPath.row)
            cell.quizViewAnswersButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
    
        return cell
        
    }
    
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @objc func cellButtonTouchAction(_ sender: UIButton){
        
        print("\n Sender hint For Like button: \(String(describing: sender.accessibilityHint))")
        let applIndex = Int(sender.accessibilityIdentifier!)
        let ApplObj = self.ApplicationListDic[applIndex!] as! NSDictionary
        
        DispatchQueue.main.async {
            if(sender.tag == 0) {
                // Start Application form
                    let topicID : String = ApplObj["topic_id"] as! String
                    let stringtopicID = "\(topicID)"
                    print(stringtopicID)
                    UserDefaults.standard.set(stringtopicID, forKey: "applicationTopicID")
                    UserDefaults.standard.set(ApplObj["title"] as! String,forKey: "ApplicationTopicTitle")
                    UserDefaults.standard.set("True",forKey: "isApplicationEditable")
                    if ApplObj["status"] as? String == "take_now" {
                        self.performSegue(withIdentifier: "applicationListToApplicationFormSegue", sender: self)
                    }
                }else if(sender.tag == 1) {
                // view Application answers
                    let appleID : String = ApplObj["topic_id"] as! String
                    let stringappleID = "\(appleID)"
                    print(stringappleID)
                    UserDefaults.standard.set(stringappleID, forKey: "applicationTopicID")
                    UserDefaults.standard.set(ApplObj["title"] as! String,forKey: "ApplicationTopicTitle")
                
                    UserDefaults.standard.set("False",forKey: "isApplicationEditable")
                
                    if ApplObj["status"] as? String == "submitted" {
                        self.performSegue(withIdentifier: "applicationListToApplicationFormSegue", sender: self)
                    }
            }
        }
        
    }
    
    
    
    func getApplicationList()  {   // to get applictions list
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_application_list", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            if statusVal == "success"{
                self.ApplicationListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    self.tableView.reloadData()
                    //                    print("\n \n ## QuizeList List \(self.ApplicationListDic as! [Any])")
                    if self.ApplicationListDic.count < 1 {
                        self.listHeddingLabel.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
                        self.listHeddingLabel.text = "No Application Found For You"
                    }
                }
            }else{
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
