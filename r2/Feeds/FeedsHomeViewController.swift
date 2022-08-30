//
//  FeedsHomeViewController.swift
//  r2
//
//  Created by NonStop io on 18/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import UserNotifications
import MessageUI
import SDWebImage
import NVActivityIndicatorView

class FeedsHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var writeNewPostButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var isScrollDownComments : Bool = false
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var postsDict:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var pageNumber = 1
    var isDataLoading:Bool=false
    var pageNumberToBeChanged: Bool = false
    var PostListDic: NSDictionary!
    let refreshControl = UIRefreshControl()
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeedsTextCell")
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        
        self.get_Posts(pageNo:self.pageNumber)
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToNextScreen))
        leftGesture.direction = .left
        self.view.addGestureRecognizer(leftGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBackScreen))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
//        UITabBar.appearance().barTintColor = UIColor.black
//        UITabBar.appearance().backgroundColor = UIColor.black

        self.navigationController?.navigationBar.barTintColor = UIColor.r2_Nav_Bar_Color
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "Internet Connection not Available!",
                                          message: "Please connect with internet and try again",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.pageNumberToBeChanged == true) {
            self.pageNumber += 1
        }
        self.activityProgress.removeFromSuperview()
        UIApplication.shared.isStatusBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        for subview in (self.navigationController?.navigationBar.subviews)! {
//            if NSStringFromClass(subview.classForCoder).contains("BarBackground") {
//                var subViewFrame: CGRect = subview.frame
//                // subViewFrame.origin.y = -20;
//                subViewFrame.size.height = 70
//                subview.frame = subViewFrame
//            }
//        }
        self.get_Posts(pageNo:self.pageNumber)
    }
    
    
    
    @objc func swipeToNextScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 2
    }
    @objc func swipeToBackScreen(sender:UISwipeGestureRecognizer) {
        tabBarController?.selectedIndex = 0
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNumber=self.pageNumber+1
                print("Page number \(self.pageNumber)")
                self.get_Posts(pageNo:self.pageNumber)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            print("\n Dragging down")
            UIView.animate(withDuration: 0.6, delay: 0.4, options:
                UIViewAnimationOptions.curveEaseOut, animations: {
                    self.navigationController?.isNavigationBarHidden = false
                    UIApplication.shared.isStatusBarHidden = false
                    self.tabBarController?.tabBar.isHidden = false
                    
            }, completion: { finished in
                
            })
            
        }else{
            // Dragging up
            print("\n Dragging up")
            UIView.animate(withDuration: 0.6, delay: 0.4, options:
                UIViewAnimationOptions.curveEaseOut, animations: {
                    self.navigationController?.isNavigationBarHidden = true
                    UIApplication.shared.isStatusBarHidden = true
                    self.tabBarController?.tabBar.isHidden = true
            }, completion: { finished in
                
            })
        }
    }
 
    
    func get_Posts(pageNo: NSInteger){
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        var strPageNum = ""
        strPageNum = "\(pageNo)"
        print("\n page number =","\(strPageNum)")
        self.view.isUserInteractionEnabled = false
        let newURL = "\(Constants.r2_baseURL)\("/get_posts/")"
        print("\n new url :: \n",newURL)
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            ]
        let dataStr: String = ("data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\", \"page_no\":\"\(pageNo)\"}" as NSString) as String
        print("POST Params for get_posts: \(dataStr)")
        let postData = NSMutableData(data: dataStr.data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: URL(string: newURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
            })
            if (error != nil) {//

                
                print("Error: \(String(describing: error))")
                DispatchQueue.main.async {
                        self.presentAlertWithOkButton(withTitle: "Error in connection", message: "Error in connection. Please check your internet connection and try again.")
                        print("Error in connection. Please check your internet connection and try again.")
                    self.activityProgress.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            } else {
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                }
                //                self.view.isUserInteractionEnabled = true
                _ = response as? HTTPURLResponse
                var errorFlag = 0
                _ = ""
                var error_msg:NSString
                //  print("Response: \(httpResponse)")
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        self.PostListDic = convertedJsonIntoDict.object(forKey: "get_posts") as? NSDictionary
                        let statusVal = self.PostListDic?["status"] as? String
                        print("\n status value \(String(describing: statusVal))")
                        if(statusVal == "success")
                        {
                            DispatchQueue.main.async {
                                
                                self.activityProgress.stopAnimating()
                                var postDictUpdated: Bool = false
                                var currentPostDictCount = ((pageNo - 1) * 10)
                                if (currentPostDictCount > 0) {
                                    currentPostDictCount -= 1
                                }
                                print("Current post dict count: \(currentPostDictCount)")
                                if (pageNo == 1) {
                                    self.postsDict =  (self.PostListDic?["data"] as! NSArray!) as! [Any]
                                    postDictUpdated = true
                                } else {
                                    let new_entries = self.PostListDic?["data"] as! [Any]
                                    if new_entries.count > 0 {
                                        for new_index in 0...(new_entries.count-1) {
                                            self.postsDict.append(new_entries[new_index])
                                        }
                                        postDictUpdated = true
                                    }
                                    if (new_entries.count == 0) {
                                        self.pageNumber = self.pageNumber - 1
                                        self.pageNumberToBeChanged = true
                                    }
                                    print("Post Dict \(self.postsDict)")
                                }
                                print("\n \n Post Dict :- \(self.postsDict)")
//                                self.indicator.stopAnimating()
                                let new_entries2 = self.PostListDic?["data"] as! [Any]
                                if (new_entries2.count > 0) {
                                    self.tableView?.reloadData()
                                }
                                if (postDictUpdated == true) {
                                    var updatedPostDictCount = self.postsDict.count
                                    if (updatedPostDictCount > 1) {
                                        updatedPostDictCount -= 1
                                    }
                                }
                            }
                            //                            self.parent_tableview?.reloadData()
                            
                        } else {
                            if self.PostListDic?["msg"] as? NSString != nil {
                                error_msg = self.PostListDic?["msg"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            errorFlag = 1
                            print("error_msg:",error_msg)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error ! Well, this is embarrassing. \n We are sorry-something has gone wrong.\n We would like to fix it for you so this does not happen again", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try Later", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                if(errorFlag == 1) {
                    DispatchQueue.main.async {
//                        let alert = UIAlertController(title: "Invalid_User_Error".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    func parsePostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {
        var convertedJsonDictResponse:NSDictionary!
        let dataStr: NSString = paramStr
        let postData = NSMutableData(data: dataStr.data(using: String.Encoding.utf8.rawValue)!)
        let r2_URL = "\(Constants.r2_baseURL)\("/")\(apiName)\("/")"
        print("\n r2_URL",r2_URL)
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
                        callback(convertedJsonDictResponse)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        })
        dataTask.resume()        
    }
    
    func bookmarkFeed(postId:String)  {     // to bookmark feed
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\"}" as String
        print("\n Bookmark param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "toggle_bookmark", paramStr: rawDataStr as NSString){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                print("\n Bookmark Result", statusVal ?? "-")
                if self.pageNumber == 1{
                    self.get_Posts(pageNo:self.pageNumber)
                }
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
    }
    
    func AlomafirePOSTRequest(apiName:String,param:String,callback: @escaping ((NSDictionary) -> ()))  {
        let para = ["data": "{\"mobile\":\"9420871066\",\"password\":\"56147180661\",\"page_no\":\"1\"}"]
        
        let r2_URL = "\(Constants.r2_baseURL)\("/")\(apiName)\("/")"
        AF.request(r2_URL, method: .post, parameters: para , headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print("response: ",response)
                let swiftyJsonVar = JSON(response.value!)
                if let resData = swiftyJsonVar["posts"].arrayObject {
                    self.postsDict = resData as! [[String:AnyObject]]
                }
                print("\n \n alomafire self.postsDict : ",self.postsDict)
                break
            case .failure(let error):
                print(error)
            }
        }
    }

 // MARK: - Table View
    
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCell", for: indexPath) as! FeedHomeTableViewCell
        
        let textFeedCell = tableView.dequeueReusableCell(withIdentifier: "FeedsTextCell", for: indexPath) as! FeedWithTextOnlyTableViewCell
        
        let dictObj = self.postsDict[indexPath.row] as! NSDictionary
        
        if  dictObj["has_video"] as! String == "False" && dictObj["has_img"] as! String == "False" {
            
//            textFeedCell.feedPostedDescLabel.text = dictObj["text"] as? String
//            textFeedCell.feedPostedDescLabel.text = cell.feedPostedDescLabel.text?.htmlToString
            
            let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, (dictObj["text"] as? String!)!) as String
            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            textFeedCell.feedPostedDescLabel.attributedText = attrStr
            
            textFeedCell.feedPostedByNameLabel.text = dictObj["title"] as? String
            textFeedCell.feedPostedTimeLabel.text = dictObj["created_at"] as? String
            textFeedCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_unfilled"), for: .normal)
            textFeedCell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
            textFeedCell.FeedLikeCount.text = dictObj["like_count"] as? String
            textFeedCell.FeedCommentCountLbl.text = dictObj["comment_count"] as? String
            
            if dictObj["is_bookmarked"] as! String == "1"{
                textFeedCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_filled"), for: .normal)
            }
            if dictObj["is_liked"] as! String == "1"{
                textFeedCell.FeedLikeButton.setImage(UIImage (named: "btn_like_filled"), for: .normal)
            }else{
                textFeedCell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
            }
            
            
            let postID : Int = dictObj["post_id"] as! Int
            let stringpostID = "\(postID)"
            
            textFeedCell.FeedBookmarkButton.tag = 0
            textFeedCell.FeedBookmarkButton.accessibilityHint = stringpostID
            textFeedCell.FeedBookmarkButton.accessibilityIdentifier = String(indexPath.row)
            textFeedCell.FeedBookmarkButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            textFeedCell.FeedLikeButton.tag = 10
            textFeedCell.FeedLikeButton.accessibilityHint = stringpostID
            textFeedCell.FeedLikeButton.accessibilityIdentifier = String(indexPath.row)
            textFeedCell.FeedLikeButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            textFeedCell.FeedCommentButton.tag = 2
            textFeedCell.FeedCommentButton.accessibilityHint = stringpostID
            textFeedCell.FeedCommentButton.accessibilityIdentifier = String(indexPath.row)
            textFeedCell.FeedCommentButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            textFeedCell.FeedShareButton.tag = 3
            textFeedCell.FeedShareButton.accessibilityHint = stringpostID
            textFeedCell.FeedShareButton.accessibilityIdentifier = String(indexPath.row)
            textFeedCell.FeedShareButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            textFeedCell.readMoreBtn.tag = 5
            textFeedCell.readMoreBtn.accessibilityHint = stringpostID
            textFeedCell.readMoreBtn.accessibilityIdentifier = String(indexPath.row)
            textFeedCell.readMoreBtn.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            

            return textFeedCell
            
        }

//            cell.feedPostedDescLabel.text = dictObj["text"] as? String
//            cell.feedPostedDescLabel.text = cell.feedPostedDescLabel.text?.htmlToString
        
            let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(Constants.r2_font_size)\">%@</span>" as NSString, (dictObj["text"] as? String!)!) as String
            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            cell.feedPostedDescLabel.attributedText = attrStr
        
        
        
            cell.feedPostedByNameLabel.text = dictObj["title"] as? String
            cell.feedPostedTimeLabel.text = dictObj["created_at"] as? String
            cell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_unfilled"), for: .normal)
            cell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
            cell.FeedLikeCount.text = dictObj["like_count"] as? String
            cell.FeedCommentCountLbl.text = dictObj["comment_count"] as? String
        
            if dictObj["is_bookmarked"] as! String == "1"{
                cell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_filled"), for: .normal)
            }
            if dictObj["is_liked"] as! String == "1"{
                cell.FeedLikeButton.setImage(UIImage (named: "btn_like_filled"), for: .normal)
            }
            
        
            cell.FeedPostedVideoView.isHidden = true
            if dictObj["has_video"] as! String == "True"{
                print("\n Show Video")
                cell.FeedPostedVideoView.backgroundColor = UIColor.clear
                cell.FeedPostedVideoView.isHidden = false
                let videoURL = NSURL(string: dictObj["video_url"] as! String)
                cell.FeedPostedVideoView.loadVideoURL(videoURL! as URL)
                cell.FeedPostedVideoView.clipsToBounds = true
//                cell.feedPostedPicImageView.isHidden = true
            }else{
                if dictObj["img_url"] != nil {
                    print("\n hide Video")
                    cell.FeedPostedVideoView.isHidden = true
                    cell.FeedPostedVideoView.backgroundColor = UIColor.clear
                    let postImageURL = "\(Constants.r2_baseURL)/\(dictObj["img_url"] as! String)"
                    cell.feedPostedPicImageView.sd_setImage(with: URL(string: postImageURL), placeholderImage: UIImage(named: "default_image.png"))
//                    let postCreatorImageURL = "\(Constants.r2_baseURL)/\(dictObj["creator_img"] as! String)"
//                    cell.feedPostedByProfilePic.downloadedFrom(url: URL(string: postCreatorImageURL)!)
                    
                }else{
//                    cell.FeedPostedVideoView.isHidden = true
                    cell.feedPostedPicImageView.image = UIImage(named:"blank_square")
                }
            }

            let postID : Int = dictObj["post_id"] as! Int
            let stringpostID = "\(postID)"

            cell.FeedBookmarkButton.tag = 0
            cell.FeedBookmarkButton.accessibilityHint = stringpostID
            cell.FeedBookmarkButton.accessibilityIdentifier = String(indexPath.row)
            cell.FeedBookmarkButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
        
            cell.FeedLikeButton.tag = 1
            cell.FeedLikeButton.accessibilityHint = stringpostID
            cell.FeedLikeButton.accessibilityIdentifier = String(indexPath.row)
            cell.FeedLikeButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
        
            cell.FeedCommentButton.tag = 2
            cell.FeedCommentButton.accessibilityHint = stringpostID
            cell.FeedCommentButton.accessibilityIdentifier = String(indexPath.row)
            cell.FeedCommentButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
        
            cell.FeedShareButton.tag = 3
            cell.FeedShareButton.accessibilityHint = stringpostID
            cell.FeedShareButton.accessibilityIdentifier = String(indexPath.row)
            cell.FeedShareButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
       
            cell.readMoreBtn.tag = 5
            cell.readMoreBtn.accessibilityHint = stringpostID
            cell.readMoreBtn.accessibilityIdentifier = String(indexPath.row)
            cell.readMoreBtn.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postObj = self.postsDict[indexPath.row] as! NSDictionary
        let postID : Int = postObj["post_id"] as! Int
        let stringpostID = "\(postID)"
        print(stringpostID)
        UserDefaults.standard.set(stringpostID, forKey: "postID")
        self.isScrollDownComments = false
        self.performSegue(withIdentifier: "FromFeedHomeViewViewMoreDetail", sender: self)
    }

    func likePost(postId:NSString){
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\"}" as NSString
        self.PostAPIWithParam(apiName: "like_post", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    print("\n $$ Like post Success")
                    if self.pageNumber == 1{
                        self.get_Posts(pageNo:self.pageNumber)
                    }
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
        }
    }
    
    @objc func refresh(){
        print("\n\n Refresh func call \n \n")
        self.pageNumber = 1
        self.get_Posts(pageNo:self.pageNumber)
        refreshControl.endRefreshing()
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
    
    // MARK: - Navigation
    
    @objc func cellButtonTouchAction(_ sender: UIButton){
        DispatchQueue.main.async {
            if(sender.tag == 0) {
                print("\n Sender hint For Bookmark button: \(String(describing: sender.accessibilityHint))")
                let postID = sender.accessibilityHint
//                self.bookmarkFeed(postId: (postID! as String))
                
                var indP: IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                indP.row = Int(sender.accessibilityIdentifier!)!

                if sender.currentImage == UIImage(named: "btn_bookmark_filled"){
                    sender.setImage(UIImage(named: "btn_bookmark_unfilled"), for: .normal)
                    self.bookmarkFeed(postId: (postID! as String))
                }else{
                    sender.setImage(UIImage(named: "btn_bookmark_filled"), for: .normal)
                    self.bookmarkFeed(postId: (postID! as String))
                }
                
                
            }else if(sender.tag == 1) {
                print("\n Sender hint For Like button: \(String(describing: sender.accessibilityHint))")
                let postID = sender.accessibilityHint
//                self.likePost(postId: postID! as NSString)
                
                var indP: IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                indP.row = Int(sender.accessibilityIdentifier!)!
                let cell = self.tableView.cellForRow(at: indP) as! FeedHomeTableViewCell
                if sender.currentImage == UIImage(named: "btn_like_filled"){
                    sender.setImage(UIImage(named: "btn_like_unfilled"), for: .normal)
                    var sp_count:Int = Int(cell.FeedLikeCount.text!)!
                    sp_count = sp_count - 1
                    cell.FeedLikeCount.text = String(sp_count)
                    self.likePost(postId: postID! as NSString)
                }else{
                    var sp_count:Int = Int(cell.FeedLikeCount.text!)!
                    sp_count = sp_count + 1
                    cell.FeedLikeCount.text = String(sp_count)
                    sender.setImage(UIImage(named: "btn_like_filled"), for: .normal)
                    self.likePost(postId: postID! as NSString)
                }
                
            }else if(sender.tag == 2){
                print("\n Sender hint For Comment button: \(String(describing: sender.accessibilityHint))")
                UserDefaults.standard.set(sender.accessibilityHint, forKey: "postID")
                self.isScrollDownComments = true
                self.performSegue(withIdentifier: "FromFeedHomeViewViewMoreDetail", sender: self)
            }else if(sender.tag == 3){
                print("\n Sender hint For Comment button: \(String(describing: sender.accessibilityHint))")
                
                let shareURL = "\(Constants.r2_baseURL)\("/share_post/")\(sender.accessibilityHint!)"
                let someText:String = "Check this from Nexo r2 app"
                let objectsToShare:URL = URL(string: shareURL)!
                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
                self.present(activityViewController, animated: true, completion: nil)
                
                
            }else if(sender.tag == 5){
                
                print("\n Sender hint For read more button: \(String(describing: sender.accessibilityHint))")
                UserDefaults.standard.set(sender.accessibilityHint, forKey: "postID")
                self.performSegue(withIdentifier: "FromFeedHomeViewViewMoreDetail", sender: self)
                
            }else if(sender.tag == 10) {
                print("\n Sender hint For Like button: \(String(describing: sender.accessibilityHint))")
                let postID = sender.accessibilityHint
                //                self.likePost(postId: postID! as NSString)
                
                var indP: IndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
                indP.row = Int(sender.accessibilityIdentifier!)!
                let cell = self.tableView.cellForRow(at: indP) as! FeedWithTextOnlyTableViewCell
                if sender.currentImage == UIImage(named: "btn_like_filled"){
                    sender.setImage(UIImage(named: "btn_like_unfilled"), for: .normal)
                    var sp_count:Int = Int(cell.FeedLikeCount.text!)!
                    sp_count = sp_count - 1
                    cell.FeedLikeCount.text = String(sp_count)
                    self.likePost(postId: postID! as NSString)
                }else{
                    var sp_count:Int = Int(cell.FeedLikeCount.text!)!
                    sp_count = sp_count + 1
                    cell.FeedLikeCount.text = String(sp_count)
                    sender.setImage(UIImage(named: "btn_like_filled"), for: .normal)
                    self.likePost(postId: postID! as NSString)
                }
                
            }
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FromFeedHomeViewViewMoreDetail") {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! viewMoreFeedDetailWithCommentViewController
            svc.isScrollDownComments = self.isScrollDownComments
        }
    }
    
    
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
