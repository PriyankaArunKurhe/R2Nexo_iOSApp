//
//  MyBatchViewController.swift
//  r2
//
//  Created by NonStop io on 12/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class MyBatchViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var batchDic:[Any] = []
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    
    @IBOutlet var batchTitleLabel: UILabel!
    @IBOutlet var batchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        self.getBatchDetail()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.batchCollectionView.frame.width/2, height: self.batchCollectionView.frame.width/2 + 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        batchCollectionView!.collectionViewLayout = layout
        
        batchTitleLabel.font = UIFont (name: Constants.r2_bold_font, size: CGFloat(Constants.r2_font_size))
        batchTitleLabel.tintColor = UIColor.black
        

        // Do any additional setup after loading the view.
    }

    
    
    @objc func swipeToBack(sender:UISwipeGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getBatchDetail()  {        // get batch detail
        
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_batch_students", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            //            let statusVal = ResDictionary["status"] as? String
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                self.batchDic = (ResDictionary["data"] as! NSArray) as! [Any]
                DispatchQueue.main.async {
                    
                    self.batchTitleLabel.text = ResDictionary["batch_name"] as? String
                    self.batchTitleLabel.text = "Batch Title : \(self.batchTitleLabel.text!)"
                    if self.batchDic.count > 0 {
                        self.batchCollectionView.reloadData()
                    }
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.batchDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Bcell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bcell", for: indexPath as IndexPath) as! MyBatchStudCollectionViewCell
        
        let dictObj = self.batchDic[indexPath.row] as! NSDictionary
        let batchStudImageURL = "\(Constants.r2_baseURL)/\(dictObj["student_picture_url"] as! String)"
        print("\n batchStudImageURL ",batchStudImageURL)
        
        Bcell.batchStudImageView.sd_setImage(with: URL(string: batchStudImageURL), placeholderImage: UIImage(named: "default_user"))
        Bcell.batchStudNameLbl.text = "\(dictObj["student_first_name"] as! String) \(dictObj["student_last_name"] as! String)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTappedForZoom))
        Bcell.batchStudImageView.addGestureRecognizer(tap)
        
        return Bcell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        let widthSize = collectionView.frame.size.width / 2
//        return CGSize(width: widthSize, height: widthSize)
//    }
    
    @objc func imageTappedForZoom(_ sender: UITapGestureRecognizer) {  // zoom image
        
        let imageView = sender.view as! UIImageView
        let zoomVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomImageCtrlrVwSID") as! ZoomImageViewController
        self.addChild(zoomVC)
        //        zoomVC.view.frame.origin.y = tableView.contentOffset.y
        zoomVC.view.frame.origin.y = self.view.frame.origin.y+(self.navigationController?.navigationBar.frame.size.height)!
        zoomVC.view.frame.size.height = self.view.frame.size.height
        zoomVC.zoomImageScrollView.display(image: imageView.image!)
        self.view.addSubview(zoomVC.view)
        zoomVC.didMove(toParent: self)
    }
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: true, completion: nil)
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
