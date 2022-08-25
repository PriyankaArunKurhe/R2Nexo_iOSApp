//
//  AssignmentViewController.swift
//  r2
//
//  Created by NonStop io on 12/01/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit

class AssignmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var AssignmentID = ""
    var AssignmentDicObj: NSDictionary!
    var isEditAssignAnswer = "true"
    
    @IBOutlet var sendAssignmentTextView: UITextView!
    
    @IBOutlet var sendAssignmentTextviewContainer: UIView!
    
    @IBOutlet var sendAssignmentButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
       
        isEditAssignAnswer = UserDefaults.standard.string(forKey: "isEditable")! as String
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.addDoneButtonOnKeyboard()
        
        sendAssignmentTextView.delegate = self
        sendAssignmentTextviewContainer.addTopBorderWithColor(color: UIColor.r2_Sub_Text_Color, width: 2)
        sendAssignmentTextView.font = UIFont(name: Constants.r2_font, size: CGFloat(Constants.r2_font_size))
        AssignmentID = UserDefaults.standard.string(forKey: "assignmentID")! as String
        
        if isEditAssignAnswer == "true" {
            sendAssignmentTextView.isEditable = true
            self.get_Assignment_By_ID(assId: AssignmentID as NSString)
            self.sendAssignmentButton.isHidden = false
            
        }else{
            sendAssignmentTextView.isEditable = false
            self.view_Assignment_Ans(assId: AssignmentID as NSString)
            self.sendAssignmentButton.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        AssignmentID = UserDefaults.standard.string(forKey: "assignmentID")! as String
        
        if isEditAssignAnswer == "true" {
            sendAssignmentTextView.isEditable = true
            self.get_Assignment_By_ID(assId: AssignmentID as NSString)
            self.sendAssignmentButton.isHidden = false
        }else{
            sendAssignmentTextView.isEditable = false
            self.view_Assignment_Ans(assId: AssignmentID as NSString)
            self.sendAssignmentButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        //        done.tintColor = UIColor.r2_Nav_Bar_Color
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.sendAssignmentTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.sendAssignmentTextView.resignFirstResponder()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0.0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
            }
            print("\n self frame y :",self.view.frame.origin.y)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = 0
            print("\n in \(keyboardFrame.cgSizeValue)keyboard hide self frame y :",self.view.frame.origin.y)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.AssignmentDicObj != nil {
                return 1
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let AssignImgVdoCell = tableView.dequeueReusableCell(withIdentifier: "AssignmentImageVideoCell", for: indexPath) as! AssignmentImgVdoTableCellTableViewCell
        let assignTextCell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTextCell", for: indexPath) as! AssignmentImgVdoTableCellTableViewCell
        
        print("\n Assignment Dic",self.AssignmentDicObj)
        
        if  AssignmentDicObj["has_video"] as! String == "False" && AssignmentDicObj["has_img"] as! String == "False" {
            let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, (AssignmentDicObj["text"] as? String!)!) as String
            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            assignTextCell.AssignmentTextView.attributedText = attrStr
            assignTextCell.AssignmentTitleLabel.text = AssignmentDicObj["title"] as? String
            assignTextCell.AssignmentCreatedDateTimeLabel.text = AssignmentDicObj["created_at"] as? String
            
            return assignTextCell
        }
        
        
        let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, (AssignmentDicObj["text"] as? String!)!) as String
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        AssignImgVdoCell.AssignmentTextView.attributedText = attrStr
        AssignImgVdoCell.AssignmentTitleLabel.text = AssignmentDicObj["title"] as? String
        AssignImgVdoCell.AssignmentCreatedDateTimeLabel.text = AssignmentDicObj["created_at"] as? String
        
        
        AssignImgVdoCell.AssignmentVideo.isHidden = true
        if AssignmentDicObj["has_video"] as! String == "True"{
            print("\n Show Video")
            AssignImgVdoCell.AssignmentVideo.backgroundColor = UIColor.clear
            AssignImgVdoCell.AssignmentVideo.isHidden = false
            let videoURL = NSURL(string: AssignmentDicObj["video_url"] as! String)
            AssignImgVdoCell.AssignmentVideo.loadVideoURL(videoURL! as URL)
            AssignImgVdoCell.AssignmentVideo.clipsToBounds = true
            //                cell.feedPostedPicImageView.isHidden = true
        }else{
            if AssignmentDicObj["img_url"] != nil {
                print("\n hide Video")
                AssignImgVdoCell.AssignmentVideo.isHidden = true
                AssignImgVdoCell.AssignmentVideo.backgroundColor = UIColor.clear
                let postImageURL = "\(Constants.r2_baseURL)/\(AssignmentDicObj["img_url"] as! String)"
                print("\n image in assignment: ",postImageURL)
                AssignImgVdoCell.AssignmentImageView.sd_setImage(with: URL(string: postImageURL), placeholderImage: UIImage(named: "default_image.png"))
                let tap = UITapGestureRecognizer(target: self, action: #selector(imageTappedForZoom))
                AssignImgVdoCell.AssignmentImageView.addGestureRecognizer(tap)
                
            }else{
                AssignImgVdoCell.AssignmentImageView.image = UIImage(named:"blank_square")
            }
        }

        return AssignImgVdoCell
        
        
    }
    
    @objc func imageTappedForZoom(_ sender: UITapGestureRecognizer) {   // for image zoom
        
        self.sendAssignmentTextView.resignFirstResponder()
        
        let imageView = sender.view as! UIImageView
        let zoomVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageCtrlrVwSID") as! ZoomImageViewController
        self.addChildViewController(zoomVC)
        //        zoomVC.view.frame.origin.y = tableView.contentOffset.y
        zoomVC.view.frame.origin.y = self.view.frame.origin.y+(self.navigationController?.navigationBar.frame.size.height)!
        zoomVC.view.frame.size.height = self.view.frame.size.height - 50.0
        zoomVC.zoomImageScrollView.display(image: imageView.image!)
        self.view.addSubview(zoomVC.view)
        zoomVC.didMove(toParentViewController: self)
    }
    
    func get_Assignment_By_ID(assId:NSString){   // get assignment details
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"ass_id\":\"\(assId)\"}" as NSString
        self.PostAPIWithParam(apiName: "start_assignment", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    
                    let AssignObj = (ResDictionary["data"] as! NSArray) as! [Any]
                    
                    self.AssignmentDicObj = AssignObj[0] as! NSDictionary
                    
                    print("\n $$ start_assignment Success \n ", self.AssignmentDicObj)
                    
                    self.tableView.reloadData()
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
        }
    }
    
    
    func view_Assignment_Ans(assId:NSString){    // to view submited assignment answers
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"ass_id\":\"\(assId)\"}" as NSString
        self.PostAPIWithParam(apiName: "view_assignment_ans", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    
                    let AssignObj = (ResDictionary["data"] as! NSArray) as! [Any]
                    
                    self.AssignmentDicObj = AssignObj[0] as! NSDictionary
                    self.sendAssignmentTextView.text = self.AssignmentDicObj["student_answer"] as? String
                    print("\n $$ given answer of Assignment Success \n ", self.AssignmentDicObj)
                    
                    self.tableView.reloadData()
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
        }
    }
    
    
    
    
    @objc func refresh(){
        print("\n\n Refresh func call \n \n")
        
        self.get_Assignment_By_ID(assId: AssignmentID as NSString)
//        refreshControl.endRefreshing()
    }
    
    @IBAction func sendAssignmentButtonTouch(_ sender: Any) {
        
        self.sendAssignmentButton.isHidden = true
        
        let alert = UIAlertController(title: "Would you like to submit your Assignment? ", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.sendAssignment()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func sendAssignment()  {    // submit assignment
        
        let assignmentText = sendAssignmentTextView.text
        var assignmentStr = ""
        assignmentStr = assignmentText!
        var stringWithoutWhiteSpace = assignmentStr.replacingOccurrences(of: "\n", with: "")
        stringWithoutWhiteSpace = stringWithoutWhiteSpace.replacingOccurrences(of: " ", with: "")
        
        assignmentStr = assignmentStr.replacingOccurrences(of: "\\", with: "\\%5C")
        assignmentStr = assignmentStr.replacingOccurrences(of: "\n", with: "\\n")
        assignmentStr = assignmentStr.replacingOccurrences(of: "&", with: "%26")
        assignmentStr = assignmentStr.replacingOccurrences(of: "\"", with: "\\%22")
        assignmentStr = assignmentStr.replacingOccurrences(of: "+", with: "%2B")
        assignmentStr = assignmentStr.replacingOccurrences(of: ";", with: "%3B")
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"assign_id\":\"\(self.AssignmentID)\",\"ans_text\":\"\(assignmentStr)\",\"answer_seen\":\"\(1)\",\"answer_attempt\":\"\(1)\"}" as String
        
        print("\n send assignment param: ",rawDataStr)
        
        if assignmentStr != "" && assignmentStr != "Write Your Assignment Here" && stringWithoutWhiteSpace != "" {
            
            self.PostAPIWithParam(apiName: "submit_assignment", paramStr: rawDataStr as NSString){  ResDictionary in
                print("\n Result Dictionary: ",ResDictionary)
                let statusVal = ResDictionary["status"] as? String
                
                print("\n response from send assignment: ",(ResDictionary["message"] as? String)!)
                
                DispatchQueue.main.async {
                    if statusVal == "success"{
                        self.sendAssignmentTextView.text = "Write Your Assignment Here"
                        self.sendAssignmentTextView.textColor = UIColor.lightGray
                        self.sendAssignmentButton.isHidden = false
                        self.sendAssignmentTextView.endEditing(true)
                        
                        let alert = UIAlertController(title: (ResDictionary["message"] as? String)!, message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
            
        }else{
            self.showToast(message: "Write something...")
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text != nil && textView.text != " ") {
            self.sendAssignmentButton.isHidden = false
        }else{
            self.sendAssignmentButton.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Write Your Assignment Here" {
            textView.text = ""
        }
        textView.textColor = UIColor.black
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
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Update Error", message: "Error in connection. Please check your internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
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
