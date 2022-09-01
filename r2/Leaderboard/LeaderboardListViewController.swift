//
//  LeaderboardListViewController.swift
//  r2
//
//  Created by NonStop io on 05/02/18.
//  Copyright © 2018 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LeaderboardListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet var badgAndRankBtnContainerView: UIView!
    
    @IBOutlet var badgeButton: UIButton!
    
    @IBOutlet var rankingButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var rankingBtnBottomBorderlabel: UILabel!
    
    @IBOutlet var badgeBtnBottomBorderLabel: UILabel!
    
    var isRankingListTable = true
    let badgeImgArr = [#imageLiteral(resourceName: "trophy_1"),#imageLiteral(resourceName: "trophy_2"),#imageLiteral(resourceName: "trophy_3"),#imageLiteral(resourceName: "trophy_4"),#imageLiteral(resourceName: "trophy_locked-1")]
    let badgeNameArr = ["Quick Learner","Master Mind!","Super Learner","The Achiever","Locked Badge"]
    let badgeDescArr = ["Completed 1 Quiz","Got 1st place on Leaderboard","Completed more than 5 Quizzes","Ranked number 1","Unlock to see the details"]
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    let refreshControl = UIRefreshControl()
    
    var ListDic:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addTopBorderWithColor(color: UIColor.r2_faintGray, width: 2)
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        rankingButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))
        badgeButton.titleLabel?.font = UIFont(name: Constants.r2_semi_bold_font, size: CGFloat(Constants.r2_font_size))

        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBackScreen))
        rightGesture.direction = .right
        
        self.view.addGestureRecognizer(rightGesture)
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        if isRankingListTable {
            self.getRankingList()
            rankingBtnBottomBorderlabel.backgroundColor = UIColor.r2_Nav_Bar_Color
            badgeBtnBottomBorderLabel.backgroundColor = UIColor.clear
            
        }else{
            self.getBadgeList()
            rankingBtnBottomBorderlabel.backgroundColor = UIColor.clear
            badgeBtnBottomBorderLabel.backgroundColor = UIColor.r2_Nav_Bar_Color
        }
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func rankingButtonTouch(_ sender: Any) {
        isRankingListTable = true
        self.getRankingList()
        rankingBtnBottomBorderlabel.backgroundColor = UIColor.r2_Nav_Bar_Color
        badgeBtnBottomBorderLabel.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func badgeButtonTouch(_ sender: Any) {
        isRankingListTable = false
        self.getBadgeList()
        rankingBtnBottomBorderlabel.backgroundColor = UIColor.clear
        badgeBtnBottomBorderLabel.backgroundColor = UIColor.r2_Nav_Bar_Color
    }
    
    
    
    
    @objc func swipeToBackScreen(sender:UISwipeGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func refresh(){
        //        self.getQuizeList()
        //        refreshControl.endRefreshing()
        
        if isRankingListTable {
            self.getRankingList()
            rankingBtnBottomBorderlabel.backgroundColor = UIColor.r2_Nav_Bar_Color
            badgeBtnBottomBorderLabel.backgroundColor = UIColor.clear
            
        }else{
            self.getBadgeList()
            rankingBtnBottomBorderlabel.backgroundColor = UIColor.clear
            badgeBtnBottomBorderLabel.backgroundColor = UIColor.r2_Nav_Bar_Color
        }
        refreshControl.endRefreshing()
    }
    
    
    
    func getBadgeList(){
        //
        tableView.reloadData()
    }
    
    
    
    func getRankingList()  {
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_leader_board_ranks", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.ListDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                    self.tableView.reloadData()
                }
            }else{
                
                DispatchQueue.main.async {
                    self.ListDic.removeAll()
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
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRankingListTable {
            return ListDic.count
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadCell") as! LeaderboardListCellTableViewCell
        let badgeCell = tableView.dequeueReusableCell(withIdentifier: "badgeCell") as! BadgeTableViewCell
        
        if isRankingListTable {
        
            if ListDic.count > 0 {
                
                cell.boostMebuttonTouch.isHidden = true
                
                let DicObj = ListDic[indexPath.row] as! NSDictionary
                cell.leadStuNameLabel.text = DicObj["user_name"] as? String
                cell.leadStuScoreLabel.text = "\(DicObj["user_points"] as! NSNumber) Points"
                cell.leadStuRankLabel.text = "\(indexPath.row+1)"
                let profImageURL = "\(Constants.r2_baseURL)/\(DicObj["user_img"] as! String)"
                cell.leadStuProfilePic.sd_setImage(with: URL(string: profImageURL), placeholderImage: UIImage(named: "default_user"))
                
                cell.boostMebuttonTouch.tag = 0
                cell.boostMebuttonTouch.accessibilityHint = DicObj["user_id"] as? String
                cell.boostMebuttonTouch.accessibilityIdentifier = String(indexPath.row)
                cell.boostMebuttonTouch.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
                
                if indexPath.row+1 == 1 || DicObj["current_user"] as! String == "True"{
                    cell.leadStuRankLabel.backgroundColor = UIColor.r2_Nav_Bar_Color
                    cell.leadStuRankLabel.textColor = UIColor.white
                    cell.backgroundColor = UIColor.r2_faintGray
                }else{
                    cell.leadStuRankLabel.backgroundColor = UIColor.white
                    if indexPath.row < 3 {
                        cell.leadStuRankLabel.textColor = UIColor.r2_Nav_Bar_Color
                    }else{
                        cell.leadStuRankLabel.textColor = UIColor.gray
                    }
                    cell.backgroundColor = UIColor.white
                }
                
                if DicObj["current_user"] as! String == "True"{
                    cell.boostMebuttonTouch.isHidden = false
                    cell.leadStuRankLabel.backgroundColor = UIColor.r2_Nav_Bar_Color
                    cell.backgroundColor = UIColor.r2_faintGray
                    cell.leadStuRankLabel.textColor = UIColor.white
                }
                
            }
        
            return cell
        }else{
            
            badgeCell.imageView?.image = badgeImgArr[indexPath.row]
            badgeCell.badgeNameLabel.text = badgeNameArr[indexPath.row]
            badgeCell.badegDescLabel.text = badgeDescArr[indexPath.row]
            
            return badgeCell
        }
    }
    

    // MARK: - Navigation
    
    
    @objc func cellButtonTouchAction(_ sender: UIButton){
        DispatchQueue.main.async {
            if(sender.tag == 0) {
//                self.presentAlertWithOkButton(withTitle: "Boost now!!", message: "(This feature is coming soon)")
                
                let popOverVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoostMeProgressSID") as! BoostMeProgrssViewViewController;                UIApplication.shared.keyWindow?.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
                
            }
        }
    }
    
    
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
