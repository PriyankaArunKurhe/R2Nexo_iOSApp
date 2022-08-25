//
//  NotificationsViewController.swift
//  r2
//
//  Created by NonStop io on 04/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    let refreshControl = UIRefreshControl()
    var NotifDic:[Any] = []
    
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToForward))
        leftGesture.direction = .left
        self.view.addGestureRecognizer(leftGesture)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        getNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        getNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextScreen))
    //    leftGesture.direction = .left
    //    self.view.addGestureRecognizer(leftGesture)
    //
    //    let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBackScreen))
    //    rightGesture.direction = .right
    //    self.view.addGestureRecognizer(rightGesture)
    
    @objc func swipeToBack(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 2
    }
    @objc func swipeToForward(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 4
    }
    
    @objc func refresh(){   // to refresh list
        self.getNotifications()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NotifDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationTableViewCell
        let notifObj = NotifDic[indexPath.row] as! NSDictionary
        
        cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        cell.NotificationTextLabel.text = notifObj["text"] as? String

        let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(16)\">%@</span>" as NSString, cell.NotificationTextLabel.text!) as String
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        cell.NotificationTextLabel.attributedText = attrStr
        cell.NotifTimeLabel.text = notifObj["date"] as? String
        
        if notifObj["notif_img"] != nil {
            let notifImageURL = "\(Constants.r2_baseURL)/\(notifObj["notif_img"] as! String)"
//            cell.NotifImageView.downloadedFrom(url: URL(string: notifImageURL)!)
            cell.NotifImageView.sd_setImage(with: URL(string: notifImageURL), placeholderImage: UIImage(named: "default_image.png"))
        }
        
        cell.NotifImageView.contentMode = UIViewContentMode.scaleAspectFill
        
        
        
        if notifObj["read"] as! String == "False" {
            cell.backgroundColor = UIColor(red: 204/255, green: 236/255, blue: 248/255, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notifObj = self.NotifDic[indexPath.row] as! NSDictionary
        
        
        let notifID : Int = notifObj["notif_id"] as! Int
        let stringNotifID = "\(notifID)"
        print(stringNotifID)
        
        self.readNotification(notifID: stringNotifID)
        
        
        
        if notifObj["redirect_to"] as! String == "Post" || notifObj["redirect_to"] as! String == "Comment" {
            let postID : Int = notifObj["redirect_id"] as! Int
            let stringpostID = "\(postID)"
//            print(stringpostID)
            UserDefaults.standard.set(stringpostID, forKey: "postID")
            self.performSegue(withIdentifier: "NotificationToViewMoreScreen", sender: self)
        }else if notifObj["redirect_to"] as! String == "Quiz" {
//            let quizID : Int = notifObj["redirect_id"] as! Int
//            let stringquizID = "\(quizID)"
//            UserDefaults.standard.set(stringquizID, forKey: "quizeID")
            UserDefaults.standard.set(true, forKey: "isQuizList")
            self.tabBarController?.selectedIndex = 2
        }else if notifObj["redirect_to"] as! String == "Application"{
//            let appID : Int = notifObj["redirect_id"] as! Int
//            let stringappID = "\(appID)"
//            UserDefaults.standard.set(stringappID, forKey: "applicationTopicID")
            performSegue(withIdentifier: "NotifToApplicationListVewSegue", sender: self)
            
        }else if notifObj["redirect_to"] as! String == "Assignment" {
            UserDefaults.standard.set(false, forKey: "isQuizList")
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    
    func readNotification(notifID:String)  {        // to read notification
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"notif_id\": \"\(notifID)\"}" as String
        
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "read_notification", paramStr: rawDataStr as NSString){  ResDictionary in
            
            print("\n \n Result Dictionary in read notification: ",ResDictionary)
            
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                DispatchQueue.main.async {
                    print("\n read notification Successfull")
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                    self.getNotifications()
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
            
        }
    }
    
    
    
    func getNotifications()  {      // to get notification list
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_notifications", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            //            let statusVal = ResDictionary["status"] as? String
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                
                self.NotifDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    print("\n row count for table view",self.NotifDic.count)
                    self.activityProgress.stopAnimating()
                    if self.NotifDic.count > 0 {
                        self.tableView.reloadData()
                    }
                    print("\n \n ## unread notification count \(ResDictionary["unread_count"] as! NSInteger)")
                        let badgeCount: Int = ResDictionary["unread_count"]! as! Int
                        self.tabBarController?.tabBar.items?[3].badgeValue = "\(badgeCount)"
                    self.showToast(message: (ResDictionary["message"] as? String)!)
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
