//
//  ProfileInfoViewController.swift
//  r2
//
//  Created by NonStop io on 01/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class ProfileInfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var titleArray = ["","My Batch","Results & Achivements", "Bookmarks","Edit Personal Details","About"]
    var profileDict: NSDictionary!
    @IBOutlet var profileTableView: UITableView!
    
    @IBOutlet var showDataLabel: UILabel!
    @IBOutlet var getProfileInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProfileInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "topProfileCell", for: indexPath) as! ProfileTopTableViewCell
        let Cell2 = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        if indexPath.row == 0 {
            cell1.profileNameLabel.text = "Rauf Shaikh"
            //            if self.profileDict.count > 0 {
            //               cell1.profileNameLabel.text = self.profileDict["student_first_name"] as? String
            //            }
            return cell1
        }else{
            if indexPath.row == 1 {
                Cell2.cellHeadingLabel.text = "GENERAL"
            }else if indexPath.row == 4{
                Cell2.cellHeadingLabel.text = "SETTINGS"
            }else{
                Cell2.cellHeadingLabel.text = ""
            }
            Cell2.cellNameLabel.text = titleArray[indexPath.row]
            return Cell2
        }
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return 200.0
    //
    //    }
    
    @IBAction func getProfileInfoButtonTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileInfoToUpdatePassword", sender: self)
    }
    
    func getProfileInfo() {
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "get_profile_info", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    self.profileDict = (ResDictionary["data"] as! NSDictionary)
                    print("\n \n PPP ",self.profileDict["student_first_name"] as? String as Any)
                    let studFirstName = self.profileDict!["student_first_name"] as? String
                    let studLastName = self.profileDict!["student_last_name"] as? String
                    UserDefaults.standard.set(studFirstName, forKey: "user_first_name")
                    UserDefaults.standard.set(studLastName, forKey: "user_last_name")
                    var studPicUrl = ""
                    studPicUrl = (self.profileDict!["student_picture_url"] as? String)!
                    let studProfilePicURL = "\(Constants.r2_baseURL)\("/")\(studPicUrl)"
                    UserDefaults.standard.set(studProfilePicURL, forKey: "user_profile_pic_URL")
                    
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
