//
//  AppDelegate.swift
//  r2
//
//  Created by NonStop io on 18/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Pushy
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var badgeCount: Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: Constants.r2_semi_bold_font, size: 19)!, NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        UINavigationBar.appearance().barTintColor = UIColor.r2_Nav_Bar_Color
        UITabBar.appearance().tintColor = UIColor.r2_skyBlue
        UITabBar.appearance().barTintColor = UIColor.r2_Tab_Bar_Color
        
        checkLogin()
        
        let pushy = Pushy(UIApplication.shared)
        pushy.register({ (error, deviceToken) in
            if error != nil {
                return print ("Registration failed: \(error!)")
            }
            print("Pushy device token: \(deviceToken)")
            UserDefaults.standard.set(deviceToken, forKey: "pushyToken")
        })

        // Listen for push notifications
        pushy.setNotificationHandler({ (data, completionHandler) in
            // Print notification payload data
            print("Received notification: \(data)")

            completionHandler(UIBackgroundFetchResult.newData)
        })
        
        if (UserDefaults.standard.string(forKey: "userID") != nil) {
            self.getAppAndOSVersion()
        }
        
        // Override point for customization after application launch.
        self.checkSwift()
        return true
    }
    
    func checkSwift() {
        #if swift(>=5.5)
                print("Swift 5.5")
                
        #elseif swift(>=5.4)
                print("Swift 5.4")
                
        #elseif swift(>=5.3)
                print("Swift 5.3")
                
        #elseif swift(>=5.2)
                print("Swift 5.2")
                
        #elseif swift(>=5.1)
                print("Swift 5.1")
                
        #elseif swift(>=5.0)
                print("Swift 5.0")
                
        #elseif swift(>=4.2)
                print("Swift 4.2")
                
        #elseif swift(>=4.1)
                print("Swift 4.1")
                
        #elseif swift(>=4.0)
                print("Swift 4.0")
                
        #elseif swift(>=3.2)
                print("Swift 3.2")
                
        #elseif swift(>=3.0)
                print("Swift 3.0")
                
        #elseif swift(>=2.2)
                print("Swift 2.2")
                
        #elseif swift(>=2.1)
                print("Swift 2.1")
                
        #elseif swift(>=2.0)
                print("Swift 2.0")
                
        #elseif swift(>=1.2)
                print("Swift 1.2")
                
        #elseif swift(>=1.1)
                print("Swift 1.1")
                
        #elseif swift(>=1.0)
                print("Swift 1.0")
                
        #endif
    }
    func notifCount(){
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
    }
    
    func checkLogin()  {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if (UserDefaults.standard.string(forKey: "userID") != nil) {
//            getNotifications()
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "TabBarSID")
        }else{
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewSID")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        if let chatID = userInfo["chatID"] as? String {
//            // here you can instantiate / select the viewController and present it
//        }
        
        if (UserDefaults.standard.string(forKey: "userID") != nil) {
            let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
            myTabBar.selectedIndex = 3 //Selecting tab here
        }
        completionHandler()
    }
    
    func getAppAndOSVersion()  {    // for OS and app version
        let bundle = Bundle.main
        let infoDictionary = bundle.infoDictionary
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
    
    
    func getNotifications()  {      // for unread notification count
        let userName = UserDefaults.standard.string(forKey: "userID")! as String
        let userPassword = UserDefaults.standard.string(forKey: "userPassword")! as String
        let rawDataStr: String = "data={\"email\":\"\(userName)\",\"password\":\"\(userPassword)\"}" as String
        print("\n comment param: ",rawDataStr)
        self.PostAPIWithParam(apiName: "get_notifications", paramStr: rawDataStr as NSString){  ResDictionary in
            print("\n Result Dictionary: ",ResDictionary)
            //            let statusVal = ResDictionary["status"] as? String
            let statusVal = ResDictionary["status"] as? String
            
            if statusVal == "success"{
                DispatchQueue.main.async {
                    print("\n \n ## unread notification count \(ResDictionary["unread_count"] as! NSInteger)")
                    let badgeCount: Int = ResDictionary["unread_count"]! as! Int
                    self.badgeCount = badgeCount
                    if #available(iOS 10.0, *) {
                        self.notifCount()
                    }
                }
            }else{
                print((ResDictionary["message"] as? String)!)
            }
        }
    }
    
    
    func PostAPIWithParam(apiName:NSString, paramStr:NSString,callback: @escaping ((NSDictionary) -> ())) {     // for API call
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
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        if (UserDefaults.standard.string(forKey: "userID") != nil) {
            getNotifications()
        }
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

