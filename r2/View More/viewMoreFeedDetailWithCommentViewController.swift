//
//  viewMoreFeedDetailWithCommentViewController.swift
//  r2
//
//  Created by NonStop io on 01/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import YouTubePlayer
import NVActivityIndicatorView

class viewMoreFeedDetailWithCommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var commentBoxView: UIView!
    @IBOutlet var sendCommentButton: UIButton!
    
    var isScrollDownComments : Bool = false
    
    let refreshControl = UIRefreshControl()
    var postDict:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    let alertLoader = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        self.commentBoxView.addTopBorderWithColor(color: UIColor(red: 194.0/255.0, green: 196.0/255.0, blue: 202.0/255.0, alpha: 1), width: 2)
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        self.addDoneButtonOnKeyboard()
        print("\n isScrollDownComments",isScrollDownComments)
        
        // loader
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alertLoader.view.addSubview(loadingIndicator)
//        present(alertLoader, animated: true, completion: nil)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Wait reloading..")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
//        commentBoxView.layer.borderColor = UIColor.black.cgColor
//        commentBoxView.layer.borderWidth = 0
        commentTextView.delegate = self
        commentTextView.text = commentTextView.text

        
//        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
        self.tableView.backgroundColor = UIColor(red:240/255.0,green:240/255.0,blue:240/255.0,alpha:1.0)
        
        self.getFeedDeatil(postId: UserDefaults.standard.string(forKey: "postID")! as String)
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
////        self.refresh()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
////        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(){
        self.getFeedDeatil(postId: UserDefaults.standard.string(forKey: "postID")! as String)
        refreshControl.endRefreshing()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if self.view.frame.origin.y == 0.0 {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
            }
            print("\n self frame y :",self.view.frame.origin.y)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ___: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKeyUIResponder.keyboardFrameEndUserInfoKeyUIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = 0
            print("\n in keyboard hide self frame y :",self.view.frame.origin.y)
        }
    }
    
    @objc func imageTappedForZoom(_ sender: UITapGestureRecognizer) {
        
        self.commentTextView.resignFirstResponder()
        
        let imageView = sender.view as! UIImageView
        let zoomVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageCtrlrVwSID") as! ZoomImageViewController
        self.addChild(zoomVC)
//        zoomVC.view.frame.origin.y = tableView.contentOffset.y
        zoomVC.view.frame.origin.y = self.view.frame.origin.y+(self.navigationController?.navigationBar.frame.size.height)!
        zoomVC.view.frame.size.height = self.view.frame.size.height - 50.0
        zoomVC.zoomImageScrollView.display(image: imageView.image!)
        self.view.addSubview(zoomVC.view)
        zoomVC.didMove(toParent: self)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.commentTextView.inputAccessoryView = doneToolbar
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.commentTextView.resignFirstResponder()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            print("\n Dragging down")
            UIView.animate(withDuration: 0.6, delay: 0.4, options:
                            UIView.AnimationOptions.curveEaseOut, animations: {
                    self.navigationController?.isNavigationBarHidden = false
                    UIApplication.shared.isStatusBarHidden = false
                    
            }, completion: { finished in
                
            })
            
        }else{
            // Dragging up
            print("\n Dragging up")
            UIView.animate(withDuration: 0.6, delay: 0.4, options:
                            UIView.AnimationOptions.curveEaseOut, animations: {
                    self.navigationController?.isNavigationBarHidden = true
                    UIApplication.shared.isStatusBarHidden = true
            }, completion: { finished in
                
            })
        }
    }
    
    
    @objc func doneButtonAction()
    {
        self.commentTextView.resignFirstResponder()
//        self.textViewDescription.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text != nil && textView.text != " ") {
            self.sendCommentButton.isHidden = false
        }else{
            self.sendCommentButton.isHidden = true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Write Your Comment Here" {
            textView.text = ""
        }
        textView.textColor = UIColor.black
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let postObj = postDict[indexPath.row] as! NSDictionary
//        if indexPath.row == 0 && postObj["has_video"] as! String == "False" && postObj["has_img"] as! String == "False" {
//            return 100.0
//        }else{
//            return 560.0
//        }
//    }
    
    
    // MARK: - Table View
    
    fileprivate var heightDictionary: [Int : CGFloat] = [:]
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = heightDictionary[indexPath.row]
        return height ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let FeedDescCell = tableView.dequeueReusableCell(withIdentifier: "feedDetailCell", for: indexPath) as! FeedDetailTableViewCell
        let FeedTextCell = tableView.dequeueReusableCell(withIdentifier: "feedTextCell", for: indexPath) as! FeedDetailTableViewCell
        
        let postObj = postDict[indexPath.row] as! NSDictionary
        
        if indexPath.row != 0 {
            // student_image
            cell.commenterNameLabel.text = postObj["student_name"] as? String
            cell.commentTextLabel.text = postObj["comment_text"] as? String
            cell.commentTimeLabel.text = postObj["comment_time"] as? String
            if postObj["student_image"] != nil {
                let commenterImageURL = "\(Constants.r2_baseURL)/\(postObj["student_image"] as! String)"
//                print("\n commenter image url ",commenterImageURL)
//                cell.commenterImage.downloadedFrom(url: URL(string: commenterImageURL)!)
                cell.commenterImage.sd_setImage(with: URL(string: commenterImageURL), placeholderImage: UIImage(named: "default_image.png"))
            }
            return cell
            
        }else{
            
            FeedTextCell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
            FeedTextCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_unfilled"), for: .normal)
            
            FeedDescCell.feedTitleLabel.text = postObj["title"] as? String
            FeedDescCell.feedPostedTimeLabel.text = postObj["created_at"] as? String
            
            let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(18)\">%@</span><BR>" as NSString, (postObj["text"] as? String)!) as String
            let attrStr = try! NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                         .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            FeedDescCell.feedDescTextView.attributedText = attrStr
            
            
            if postObj["has_video"] as? String == "True"{
                // show video
                FeedDescCell.FeedPostedVideoView.backgroundColor = UIColor.clear
                FeedDescCell.FeedPostedVideoView.isHidden = false
                let videoURL = NSURL(string: postObj["video_url"] as! String)
                FeedDescCell.FeedPostedVideoView.loadVideoURL(videoURL! as URL)
                FeedDescCell.FeedPostedVideoView.clipsToBounds = true
                FeedDescCell.feedPostedPicImageView.isHidden = true
            }else if postObj["has_img"] as! String == "True"{
                FeedDescCell.FeedPostedVideoView.isHidden = true
                FeedDescCell.feedPostedPicImageView.isHidden = false
                if postObj["img_url"] != nil {
                    let postImageURL = "\(Constants.r2_baseURL)/\(postObj["img_url"] as! String)"
//                    FeedDescCell.feedPostedPicImageView.downloadedFrom(url: URL(string: postImageURL)!)
                    FeedDescCell.feedPostedPicImageView.sd_setImage(with: URL(string: postImageURL), placeholderImage: UIImage(named: "default_image.png"))
                    let tap = UITapGestureRecognizer(target: self, action: #selector(imageTappedForZoom))
                    FeedDescCell.feedPostedPicImageView.addGestureRecognizer(tap)
                }
                
            }else if  postObj["has_video"] as! String == "False" && postObj["has_img"] as! String == "False" {
//                    FeedDescCell.feedPostedPicImageView.image = UIImage(named: "blank_square")
                FeedTextCell.feedPostedPicImageView.image = imageWithImage(image: UIImage(named: "blank_square")!, scaledToSize: CGSize(width: 20, height: 20))
                
                FeedTextCell.feedTitleLabel.text = postObj["title"] as? String
                FeedTextCell.feedPostedTimeLabel.text = postObj["created_at"] as? String
                
                let modifiedFont = NSString(format:"<span style=\"font-family: \(Constants.r2_font), 'HelveticaNeue'; font-size: \(18)\">%@</span><BR>" as NSString, (postObj["text"] as? String)!) as String
                let attrStr = try! NSAttributedString(
                    data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                    options:[.documentType: NSAttributedString.DocumentType.html,
                             .characterEncoding: String.Encoding.utf8.rawValue],
                    documentAttributes: nil)
                FeedTextCell.feedDescTextView.attributedText = attrStr
                
                if postObj["is_liked"] as! String == "1"{
                    FeedTextCell.FeedLikeButton.setImage(UIImage (named: "btn_like_filled"), for: .normal)
                }else{
                    FeedTextCell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
                }
                
                if postObj["is_bookmarked"] as! String == "1"{
                    FeedTextCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_filled"), for: .normal)
                }else{
                    FeedTextCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_unfilled"), for: .normal)
                }
                
                let postID : Int = postObj["post_id"] as! Int
                let stringpostID = "\(postID)"
                FeedTextCell.FeedBookmarkButton.tag = 0
                FeedTextCell.FeedBookmarkButton.accessibilityHint = stringpostID
                FeedTextCell.FeedBookmarkButton.accessibilityIdentifier = String(indexPath.row)
                FeedTextCell.FeedBookmarkButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
                
                FeedTextCell.FeedLikeButton.tag = 1
                FeedTextCell.FeedLikeButton.accessibilityHint = stringpostID
                FeedTextCell.FeedLikeButton.accessibilityIdentifier = String(indexPath.row)
                FeedTextCell.FeedLikeButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
                
                FeedTextCell.FeedShareButton.tag = 3
                FeedTextCell.FeedShareButton.accessibilityHint = stringpostID
                FeedTextCell.FeedShareButton.accessibilityIdentifier = String(indexPath.row)
                FeedTextCell.FeedShareButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
                
                FeedTextCell.FeedLikeCount.text = postObj["like_count"] as? String
                FeedTextCell.FeedCommentCountLbl.text = postObj["comment_count"] as? String
                
                return FeedTextCell
                
            }
            
            if postObj["is_liked"] as! String == "1"{
                FeedDescCell.FeedLikeButton.setImage(UIImage (named: "btn_like_filled"), for: .normal)
            }else{
                FeedDescCell.FeedLikeButton.setImage(UIImage (named: "btn_like_unfilled"), for: .normal)
            }
            
            if postObj["is_bookmarked"] as! String == "1"{
                FeedDescCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_filled"), for: .normal)
            }else{
                FeedDescCell.FeedBookmarkButton.setImage(UIImage (named: "btn_bookmark_unfilled"), for: .normal)
            }
            
            let postID : Int = postObj["post_id"] as! Int
            let stringpostID = "\(postID)"
            FeedDescCell.FeedBookmarkButton.tag = 0
            FeedDescCell.FeedBookmarkButton.accessibilityHint = stringpostID
            FeedDescCell.FeedBookmarkButton.accessibilityIdentifier = String(indexPath.row)
            FeedDescCell.FeedBookmarkButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            FeedDescCell.FeedLikeButton.tag = 1
            FeedDescCell.FeedLikeButton.accessibilityHint = stringpostID
            FeedDescCell.FeedLikeButton.accessibilityIdentifier = String(indexPath.row)
            FeedDescCell.FeedLikeButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            FeedDescCell.FeedShareButton.tag = 3
            FeedDescCell.FeedShareButton.accessibilityHint = stringpostID
            FeedDescCell.FeedShareButton.accessibilityIdentifier = String(indexPath.row)
            FeedDescCell.FeedShareButton.addTarget(self, action: #selector(self.cellButtonTouchAction), for: .touchUpInside)
            
            FeedDescCell.FeedLikeCount.text = postObj["like_count"] as? String
            FeedDescCell.FeedCommentCountLbl.text = postObj["comment_count"] as? String
            
            return FeedDescCell
        }
        
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    @objc func cellButtonTouchAction(_ sender: UIButton){
        DispatchQueue.main.async {
            if(sender.tag == 0) {
                print("\n Sender hint For Bookmark button: \(String(describing: sender.accessibilityHint))")
                let postID = sender.accessibilityHint
                self.bookmarkFeed(postId: (postID! as String))
            }else if(sender.tag == 1) {
                print("\n Sender hint For Like button: \(String(describing: sender.accessibilityHint))")
                let postID = sender.accessibilityHint
                self.likePost(postId: postID! as NSString)
            }else if(sender.tag == 2){
//                print("\n Sender hint For Comment button: \(String(describing: sender.accessibilityHint))")
//                UserDefaults.standard.set(sender.accessibilityHint, forKey: "postID")
//                self.performSegue(withIdentifier: "FromFeedHomeViewViewMoreDetail", sender: self)
            }else if(sender.tag == 3){
                print("\n Sender hint For Comment button: \(String(describing: sender.accessibilityHint))")
                
                let shareURL = "\(Constants.r2_baseURL)\("/share_post/")\(sender.accessibilityHint!)"
                let someText:String = "Check this from Nexo r2 app"
                let objectsToShare:URL = URL(string: shareURL)!
                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
                self.present(activityViewController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func BackButtonTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
//    let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
//    rightGesture.direction = .right
//    self.view.addGestureRecognizer(rightGesture)
    
    @objc func swipeToBack(sender:UISwipeGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
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
                    self.presentAlertWithOkButton(withTitle: "Error in connection", message: "Error in connection. Please check your internet connection and try again.")
                    print("Error in connection. Please check your internet connection and try again.")
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
                    print("Server Returns Status Code: \(httpResponse?.statusCode ?? 500)"+"\n")
                    self.showToast(message: "Server Returns Status Code: \(httpResponse?.statusCode ?? 500)" )
                }
            }
        })
        dataTask.resume()
    }
    
    @IBAction func sendCommentButtonTouch(_ sender: Any) {
        DispatchQueue.main.async {
        self.sendCommentButton.isHidden = true
        self.sendComment(postId: UserDefaults.standard.string(forKey: "postID")! as String)
        }
    }
    
    func sendComment(postId:String)  {   // to comment on feed
        
        let commentText = commentTextView.text
        var commentStr = ""
        commentStr = commentText!
        var stringWithoutWhiteSpace = commentStr.replacingOccurrences(of: "\n", with: "")
        stringWithoutWhiteSpace = stringWithoutWhiteSpace.replacingOccurrences(of: " ", with: "")
        print("string without space",stringWithoutWhiteSpace)
        
        commentStr = commentStr.replacingOccurrences(of: "\\", with: "\\%5C")
        commentStr = commentStr.replacingOccurrences(of: "\n", with: "\\n")
        commentStr = commentStr.replacingOccurrences(of: "&", with: "%26")
        commentStr = commentStr.replacingOccurrences(of: "\"", with: "\\%22")
        commentStr = commentStr.replacingOccurrences(of: "+", with: "%2B")
        commentStr = commentStr.replacingOccurrences(of: ";", with: "%3B")
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\",\"comment_text\":\"\(commentStr)\"}" as String
        print("\n comment param: ",rawDataStr)
        
        if commentStr != "" && commentStr != "Write Your Comment Here" && stringWithoutWhiteSpace != "" {
            
            self.PostAPIWithParam(apiName: "add_comment", paramStr: rawDataStr as NSString){  ResDictionary in
                print("\n Result Dictionary: ",ResDictionary)
                let statusVal = ResDictionary["status"] as? String
                
                print("\n response from send comment: ",(ResDictionary["message"] as? String)!)
                
                DispatchQueue.main.async {
                    if statusVal == "success"{
                        self.commentTextView.text = "Write Your Comment Here"
                        self.commentTextView.textColor = UIColor.lightGray
                        self.sendCommentButton.isHidden = false
                        self.commentTextView.endEditing(true)
                        self.isScrollDownComments = true
//                        self.tableViewScrollToBottom(animated: true)
                    }
                    
                    if self.postDict.count > 0 {
                        self.getFeedDeatil(postId: UserDefaults.standard.string(forKey: "postID")! as String)
                        self.tableView.reloadData()
                    }
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
            
        }else{
            self.showToast(message: "Write something...")
        }
        
    }
    
    func likePost(postId:NSString){     // like feed
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\"}" as NSString
        self.PostAPIWithParam(apiName: "like_post", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    print("\n $$ Like post Success")
                    self.getFeedDeatil(postId: postId as String)
                    self.showToast(message: (ResDictionary["message"] as? String)!)
                }
            }
        }
    }
    
    func bookmarkFeed(postId:String)  {     // bookmark feeds
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\"}" as String
        print("\n Bookmark param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "toggle_bookmark", paramStr: rawDataStr as NSString){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                print("\n Bookmark Result", statusVal ?? "-")
                self.getFeedDeatil(postId: postId as String)
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
    }
    
    func getFeedDeatil(postId:String)  { // to get feed detail
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\",\"post_id\":\"\(postId)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_comments", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
//            let statusVal = ResDictionary["status"] as? String
            self.postDict = (ResDictionary["comments"] as! NSArray) as! [Any]
            DispatchQueue.main.async {
                    self.activityProgress.stopAnimating()
                print("\n row count for table view",self.postDict.count)
                if self.postDict.count > 0 {
                    self.tableView.reloadData()
                }
                if self.isScrollDownComments {
                    self.tableViewScrollToBottom(animated: false)
                    
                    self.isScrollDownComments = false
                }
                self.showToast(message: (ResDictionary["message"] as? String)!)
            }
        }
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
