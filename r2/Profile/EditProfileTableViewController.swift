//
//  EditProfileTableViewController.swift
//  r2
//
//  Created by NonStop io on 25/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var batchComanyImage: UIImageView!
    @IBOutlet var ProfileImageView: UIImageView!
    @IBOutlet var profileNameLbl: UILabel!
    
    @IBOutlet var userProfileNameTextField: UITextField!
    @IBOutlet var userProfileEmailIDTextField: UITextField!
    
    @IBOutlet var submitCellView: UIView!
    
    let imagePicker = UIImagePickerController()
    var userName = UserDefaults.standard.string(forKey: "userID")! as String
    var userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
    var profileDict: NSDictionary!
    
    let activityProgress = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width/2) - 25.0, y: (UIScreen.main.bounds.size.height/2) - 25.0, width: 51, height: 51), type: NVActivityIndicatorType.ballScaleRippleMultiple, color: UIColor.r2_Nav_Bar_Color)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
        self.activityProgress.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.50)
        self.view.addSubview(activityProgress)
        imagePicker.delegate = self
        ProfileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        ProfileImageView.layer.cornerRadius = ProfileImageView.frame.size.width / 2
        ProfileImageView.clipsToBounds = true
        ProfileImageView.contentMode = UIView.ContentMode.scaleToFill
        userProfileEmailIDTextField.isEnabled = false
        submitCellView.backgroundColor = UIColor.r2_Tab_Bar_Color
        self.getProfileInfo()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userName = UserDefaults.standard.string(forKey: "userID")! as String
        userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activityProgress.removeFromSuperview()
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
    
    @IBAction func changeImageButtonTouch(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                                     didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage.rawValue] as! UIImage
        ProfileImageView.contentMode = .scaleAspectFill
        ProfileImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getProfileInfo() {   // to get profile info
        
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "get_profile_info", paramStr: rawDataStr){  ResDictionary in
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    self.activityProgress.stopAnimating()
                    print("\n success in get profile ", ResDictionary)
                    self.profileDict = ResDictionary["data"] as! NSDictionary
                    print("\n \n PPP ",self.profileDict["student_first_name"] as! String)
                    let fullName = "\(self.profileDict["student_first_name"] as! String) \(self.profileDict["student_last_name"] as! String)"
                    self.profileNameLbl.text = fullName
                    self.userProfileNameTextField.text = fullName
                    self.userProfileEmailIDTextField.text = self.userName
                    let profileImageURL = "\(Constants.r2_baseURL)/\(self.profileDict["student_picture_url"] as! String)"
                    self.ProfileImageView.downloadedFrom(url: URL(string: profileImageURL)!)
                    self.ProfileImageView.contentMode = UIView.ContentMode.scaleAspectFill
                    let comapnyImageURL = "\(Constants.r2_baseURL)/\(self.profileDict["company_image"] as! String)"
                    self.batchComanyImage.downloadedFrom(url: URL(string: comapnyImageURL)!)
                    
                }
            }
        }
    }
    
    func ChangePassword() {
        
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\", \"new_password\":\"\(userPassword)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "change_password", paramStr: rawDataStr){  ResDictionary in
            
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                if statusVal == "success"{
                    print("\n \n  Change Password $$$$$$$ Success ")
                }
            }
        }
        
    }
    
    func UpdateProfile() {   // to update profile
        DispatchQueue.main.async {
            self.activityProgress.startAnimating()
        }
        
        let imageProfCompressed = self.ProfileImageView.image?.resizeWith(width: 380)
        let imageProf = imageProfCompressed!.pngData()
        var imageProfStr = imageProf?.base64EncodedString()
        imageProfStr = imageProfStr?.replacingOccurrences(of: " ", with: "\n")
        
        let fullName = self.userProfileNameTextField.text
        let fullNameArr = fullName?.components(separatedBy: " ")
        var name = ""
        var surname = ""
        if fullNameArr?.count == 1 {
            name = fullNameArr![0]
            surname = ""
        }else{
            name = fullNameArr![0]
            surname = fullNameArr![1]
        }
        let rawDataStr: NSString = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\", \"first_name\":\"\(name)\",\"last_name\":\"\(surname)\",\"new_password\":\"\(userPassword)\",\"picture_url\":\"\(imageProfStr!)\"}" as NSString
        self.parsePostAPIWithParam(apiName: "update_profile", paramStr: rawDataStr){  ResDictionary in
            
            let statusVal = ResDictionary["status"] as? String
            DispatchQueue.main.async {
                self.activityProgress.stopAnimating()
                
                if statusVal == "success"{
                    
                    let alertController = UIAlertController(title: "Profile updated successfully!", message: "", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.getProfileInfo()
                }else{
                    self.showToast(message: (ResDictionary["message"] as? String)!)
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
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 5 {
            
            let alertController = UIAlertController(title: "Would You Like To Update Information?", message: "OK to Update", preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                
            }
            let OKAction = UIAlertAction(title: "Update", style: .default) { action in
                self.UpdateProfile()
            }
            alertController.addAction(CancelAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else if indexPath.row == 3{
            performSegue(withIdentifier: "EditProfileToChangePasswordSegue", sender: self)
        }
    }
    
    @IBAction func changePasswordButtonTouch(_ sender: Any) {
        performSegue(withIdentifier: "EditProfileToChangePasswordSegue", sender: self)
    }
    
    
    @IBAction func logoutButtonTouch(_ sender: Any) {
        
        let domain = Bundle.main.bundleIdentifier!;        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize();   print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
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


    // MARK: - Navigation
     
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
