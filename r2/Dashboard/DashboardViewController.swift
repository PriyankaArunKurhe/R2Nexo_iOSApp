//
//
//  r2
//
//  Created by NonStop io on 05/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//



import UIKit
import UserNotifications
import Crashlytics

class DashboardViewController: UIViewController,UIWebViewDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UNUserNotificationCenterDelegate {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var menuCollectionView: UICollectionView!
    @IBOutlet var leaderboardlabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var dashboardProfileImageView: UIImageView!
    @IBOutlet var dashboardProfileName: UILabel!
    @IBOutlet var boostTextLabel: UILabel!
    
    var NotifDic:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var studID = UserDefaults.standard.string(forKey: "student_id")! as String
    var MenuImagesArr: [UIImage] = [ UIImage(named: "quiz_index_logo")!, UIImage(named: "assignment_index_logo")!,  UIImage(named: "rank_index_logo")!, UIImage(named: "feeds_index_logo")!]
    var menuTitleArr: [String] = ["Quizzes","Assignments","My Rank","Application"]
    var menuDonowArr: [String] = ["Take quizzes now!","Do assignments now!","View Leaderboard!","View application now!"]
    var menuCountArr: [String] = ["","","",""]
    var dashboardCountDic: [Any] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
        
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuCollectionView.isScrollEnabled = true/* Device is iPad */
            webView.scrollView.isScrollEnabled = true
            webView.scrollView.bounces = false
        }else {
            menuCollectionView.isScrollEnabled = false
            webView.scrollView.isScrollEnabled = false
            webView.scrollView.bounces = false
        }
        
        self.getAppAndOSVersion()
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextScreen))
        leftGesture.direction = .left
        self.view.addGestureRecognizer(leftGesture)
        
        dashboardProfileName.font = UIFont (name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size-3))
        boostTextLabel.font = UIFont (name: Constants.r2_font, size: CGFloat(Constants.r2_font_size-4))
        webView.scrollView.delegate = self
        
        print("\n profile pic url from user default ",UserDefaults.standard.string(forKey: "user_profile_pic_URL")! as String)
        
        dashboardProfileImageView.contentMode = UIViewContentMode.scaleAspectFill
        dashboardProfileImageView.layer.cornerRadius = dashboardProfileImageView.frame.size.width / 2
        dashboardProfileImageView.clipsToBounds = true
        
//        self.backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "dashboard_background")!)
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "dashboard_background")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        let attrs : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont(name: Constants.r2_semi_bold_font, size: 22)!,
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "Leaderboard",
                                                        attributes: attrs)
        leaderboardlabel.attributedText = attributeString
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2 )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        menuCollectionView!.collectionViewLayout = layout
        
        self.menuCollectionView.isHidden = false
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]],
                                                                completionHandler: { (granted, error) in
                                                                    // Handle Error
                                                                    print("\n or in Local Notification")
        })
        
        UNUserNotificationCenter.current().delegate = self
        
        // Do any additional setup after loading the view.
    }
    
//    @objc func crashButtonTapped(_ sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
//        self.navigationController?.isNavigationBarHidden = true
        
        let r2_URL = "\(Constants.r2_baseURL)\("/ranking_graph/")\(studID)\("/")"
        print("\n graph URL ",r2_URL)
        let url = NSURL (string: r2_URL)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)
        
        
//        dashboardProfileName.text = "\(UserDefaults.standard.string(forKey: "user_first_name")! as String) \(UserDefaults.standard.string(forKey: "user_last_name")! as String)"
//        dashboardProfileImageView.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: "user_profile_pic_URL")! as String), placeholderImage: UIImage(named: "default_user.png"))
        
//        UIApplication.shared.isStatusBarHidden = true
        
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        
        getNotifications()
        getDashboardCount()
        
//        self.view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        UIView.animate(withDuration: 5.0, animations: { () -> Void in
//            self.view.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0);
//        },
//                       completion: { finished in
//                        UIView.animate(withDuration: 5.0, animations: { () -> Void in
//                            self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//                        }, completion: { finished in
//                            //other color do the same
//                        })
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func getAppAndOSVersion()  {    // to get app version
        let bundle = Bundle.main
        let infoDictionary = bundle.infoDictionary
        print("app_version:\(infoDictionary?["CFBundleShortVersionString"] as! String)")
        
        let systemVersion = UIDevice.current.systemVersion
        print("\n iOS Vesion \(systemVersion) \n current version",infoDictionary?["CFBundleShortVersionString"] as! String)
        let userName = UserDefaults.standard.string(forKey: "userID")! as String
        let userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"os_version\":\"\(systemVersion)\",\"app_version\":\"\(infoDictionary?["CFBundleShortVersionString"] as! String)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "set_version", paramStr: rawDataStr as NSString){  ResDictionary in
            
            let statusVal = ResDictionary["status"] as? String
            if statusVal == "success"{
                print((ResDictionary["message"] as? String)!)
            }else{
                print((ResDictionary["message"] as? String)!)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.isStatusBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {  // for navigation on notification screen
    
    self.tabBarController?.selectedIndex = 3
    
    completionHandler()
    }
    
    
    @objc func swipeToNextScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        if (scrollView.contentOffset.y < 0){
//            //reach top
//            print("\n Reach Top")
//            webView.reload()
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DMcell = collectionView.dequeueReusableCell(withReuseIdentifier: "DMCell", for: indexPath as IndexPath) as! DashboardMenuCollectionViewCell
        DMcell.menuBackgroundImage.image = MenuImagesArr[indexPath.row]
//        DMcell.layer.borderWidth = 2.0
//        DMcell.layer.borderColor = UIColor.red.cgColor
        DMcell.menuTitleLabel.text = self.menuTitleArr[indexPath.row]
        
        let attrs : [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont(name: Constants.r2_semi_bold_font, size: 10)!,
            NSAttributedStringKey.foregroundColor : UIColor.r2_skyBlue,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: self.menuDonowArr[indexPath.row],
                                                        attributes: attrs)
        DMcell.menuDoNowLabel.attributedText = attributeString
        
        
        
        if indexPath.row == 0 {
            DMcell.menuStatusCountLabel.text = self.menuCountArr[indexPath.row] + " Pending"
        }else if indexPath.row == 1 {
            DMcell.menuStatusCountLabel.text = self.menuCountArr[indexPath.row] + " Pending"
        }else if indexPath.row == 2 {
            DMcell.menuStatusCountLabel.text = self.menuCountArr[indexPath.row]
            let numChars = DMcell.menuStatusCountLabel.text?.characters.count ?? 0
            if numChars != 0{
                let font:UIFont? = UIFont(name: Constants.r2_font, size:15)
                let fontSuper:UIFont? = UIFont(name: Constants.r2_font, size:12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: DMcell.menuStatusCountLabel.text!, attributes: [.font:font!])
                
                attString.setAttributes([.font:fontSuper!,.baselineOffset:numChars], range: NSRange(location:numChars-2,length:2))
                DMcell.menuStatusCountLabel.attributedText = attString
            }
            
        }else if indexPath.row == 3 {
            DMcell.menuStatusCountLabel.text = self.menuCountArr[indexPath.row] + " Pending"
        }
        
        
        return DMcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: "isQuizList")
            self.tabBarController?.selectedIndex = 2
        }else if indexPath.row == 1 {
            UserDefaults.standard.set(false, forKey: "isQuizList")
            self.tabBarController?.selectedIndex = 2
        }else if indexPath.row == 2 {
            UserDefaults.standard.set(false, forKey: "isQuizList")
            performSegue(withIdentifier: "DashboardToLeaderboardSegue", sender: self)
        }else if indexPath.row == 3 {
//            self.tabBarController?.selectedIndex = 1
            performSegue(withIdentifier: "DashboardToApplicationListSegue", sender: self)
        }
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        let widthSize = collectionView.frame.size.width / 2
//        return CGSize(width: widthSize, height: widthSize)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 5
//    }
    
//
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 5
//    }
    
    
    func getNotifications()  {  // unreade notification count
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_notifications", paramStr: rawDataStr as NSString){  ResDictionary in
//            print("\n Result Dictionary: ",ResDictionary)
            //            let statusVal = ResDictionary["status"] as? String
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.NotifDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    
//                    print("\n \n ## unread notification count \(ResDictionary["unread_count"] as! NSInteger)")
                    let badgeCount: Int = ResDictionary["unread_count"]! as! Int
                    self.tabBarController?.tabBar.items?[3].badgeValue = "\(badgeCount)"
                    
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
            
        }
    }
    
    func getDashboardCount()  { // for count
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n getDashboardCount param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_dashboard_count", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dashboard Dictionary: ",ResDictionary)
            //            let statusVal = ResDictionary["status"] as? String
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
    //                self.dashboardCountDic = (ResDictionary["data"] as! NSArray) as! [Any]
                    DispatchQueue.main.async {
//                    self.menuCountArr.insert((ResDictionary["pending_quiz"] as? String)!, at: 0)
                        
                    self.menuCountArr[0] = (ResDictionary["pending_quiz"] as? String)!
                        
//                    self.menuCountArr.insert((ResDictionary["pending_assignments"] as? String)!, at: 1)
                        
                    self.menuCountArr[1] = (ResDictionary["pending_assignments"] as? String)!
                        
//                    self.menuCountArr.insert((ResDictionary["rank"] as? String)!, at: 2)
                        
                    self.menuCountArr[2] = (ResDictionary["rank"] as? String)!
                        
//                    self.menuCountArr.insert((ResDictionary["feed_count"] as? String)!, at: 3)
                    
                    self.menuCountArr[3] = (ResDictionary["pending_application"] as? String)!
                        
                    print("\n \n menu count array \(self.menuCountArr)")
                    self.menuCollectionView.reloadData()
                }
            }else{
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
            
        }
    }
    
    
    func PostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {  // For API call
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
                self.presentAlertWithOkButton(withTitle: "Connection Error!", message: "Error in connection. Please check your internet connection and try again")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                do{
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        convertedJsonDictResponse = convertedJsonIntoDict.object(forKey: apiName) as? NSDictionary
//                        print("\n \n response data convertedJsonDictResponse",convertedJsonDictResponse)
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
//                    self.presentAlertWithOkButton(withTitle: "Server Error!", message: "Please try again")
                }
            }
        })
        dataTask.resume()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func boostNowButtonTouch(_ sender: Any) {

//        Crashlytics.sharedInstance().crash()
        
//        self.presentAlertWithOkButton(withTitle: "Boost now!!", message: "(This feature is coming soon)")
        
        let popOverVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoostMeProgressSID") as! BoostMeProgrssViewViewController
//        self.view.addSubview(popOverVC.view)
        UIApplication.shared.keyWindow?.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MeditatinViewControllerSID") as! MeditationViewController
//        self.present(vc, animated: true, completion: nil)
        
        
//        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MeditatinViewControllerSID") as! MeditationViewController
//        let navController = UINavigationController(rootViewController: VC1)
//        self.present(navController, animated:true, completion: nil)
        
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
