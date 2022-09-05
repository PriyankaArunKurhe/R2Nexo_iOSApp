//
//  ProfileTableViewController.swift
//  r2
//
//  Created by NonStop io on 25/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ProfileTableViewController: UITableViewController {
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var profileDict: NSDictionary!
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var batchComanyImage: UIImageView!
    @IBOutlet var ProfileImageView: UIImageView!
    @IBOutlet var profileNameLbl: UILabel!
    @IBOutlet var bookmarkCountLbl: UILabel!
    @IBOutlet var logoutLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // #c96877 rgb(201,104,119) logout button color
        //        self.tableView.separatorColor = UIColor.lightGray
        logoutLabel.textColor = UIColor(red: 208/255.0, green: 29.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBackScreen))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        //        refreshControl?.attributedTitle = NSAttributedString(string: "Wait reloading..")
        //        refreshControl?.addTarget(self, action: #selector(self.refresh), for:      UIControlEvents.valueChanged)
        //        tableView.addSubview(refreshControl!)
        self.getProfileInfo()
        ProfileImageView.contentMode = UIView.ContentMode.scaleToFill
        ProfileImageView.layer.cornerRadius = ProfileImageView.frame.size.width / 2
        ProfileImageView.clipsToBounds = true
        bookmarkCountLbl.backgroundColor = UIColor.r2_Nav_Bar_Color
        bookmarkCountLbl.layer.cornerRadius = bookmarkCountLbl.frame.width/2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getProfileInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
    }
    
    @objc func swipeToBackScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 3
    }
    //    @objc func refresh(){
    //        self.getProfileInfo()
    ////        refreshControl?.endRefreshing()
    //    }
    
    func logout() {
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "logout", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    self.activityProgress.stopAnimating()
                    self.signOut()
                }
            }
        }
        
    }
    
    func getProfileInfo() {
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "get_profile_info", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    self.activityProgress.stopAnimating()
                    self.profileDict = (ResDictionary["data"] as! NSDictionary)
                    print("\n \n PPP ",self.profileDict["student_first_name"] as! String)
                    
                    let fullName = "\(self.profileDict["student_first_name"] as! String) \(self.profileDict["student_last_name"] as! String)"
                    self.profileNameLbl.text = fullName
                    
                    let comapnyImageURL = "\(Constants.r2_baseURL)/\(self.profileDict["company_image"] as! String)"
                    self.batchComanyImage.downloadedFrom(url: URL(string: comapnyImageURL)!)
                    let profileImageURL = "\(Constants.r2_baseURL)/\(self.profileDict["student_picture_url"] as! String)"
                    print("\n Profile URL in profile Info ",profileImageURL)
                    let studFirstName = self.profileDict!["student_first_name"] as? String
                    let studLastName = self.profileDict!["student_last_name"] as? String
                    UserDefaults.standard.set(studFirstName, forKey: "user_first_name")
                    UserDefaults.standard.set(studLastName, forKey: "user_last_name")
                    var studPicUrl = ""
                    studPicUrl = (self.profileDict!["student_picture_url"] as? String)!
                    let studProfilePicURL = "\(Constants.r2_baseURL)\("/")\(studPicUrl)"
                    UserDefaults.standard.set(studProfilePicURL, forKey: "user_profile_pic_URL")
                    self.bookmarkCountLbl.text = self.profileDict["bookmark_count"] as? String
                    self.ProfileImageView.downloadedFrom(url: URL(string: profileImageURL)!)
                    self.ProfileImageView.contentMode = UIView.ContentMode.scaleAspectFill
                    self.profileTableView.reloadData()
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
                        print("\n \n response data convertedJsonDictResponse",convertedJsonDictResponse as Any)
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            performSegue(withIdentifier: "profileToEditProfile", sender: self)
        }else if indexPath.row == 3 {
            performSegue(withIdentifier: "profileToBookmarkListSID", sender: self)
        }else if indexPath.row == 1 {
            performSegue(withIdentifier: "profileToMyBatchViewController", sender: self)
        }else if indexPath.row == 5 {
            let bundle = Bundle.main
            let infoDictionary = bundle.infoDictionary
            print("app_version:\(infoDictionary?["CFBundleShortVersionString"] as! String)")
            self.presentAlertWithOkButton(withTitle: "About Us", message: "App Version: \(infoDictionary?["CFBundleShortVersionString"] as! String)")
        }
        else if indexPath.row == 6 {
            
            let alertController = UIAlertController(title: "Would You Like To Logout From App?", message: "Yes to Logout", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "No", style: .cancel) { action in
                
            }
            let OKAction = UIAlertAction(title: "Yes", style: .default) { action in
                
                self.logout()
                
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func signOut() {      // for signout
        UserDefaults.standard.removeObject(forKey:"userID")
        UserDefaults.standard.removeObject(forKey:"userPassword")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "SignInViewSID") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        self.presentAlertWithOkButton(withTitle: "You logged out successfully", message: "")
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
