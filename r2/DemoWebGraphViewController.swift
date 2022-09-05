//
//  DemoWebGraphViewController.swift
//  r2
//
//  Created by NonStop io on 01/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
import WebKit
class DemoWebGraphViewController: UIViewController,UIWebViewDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.delegate = self
        let url = NSURL (string: "http://192.168.0.8:8000/ranking_graph/")
        
//        let newURL
        let requestObj = NSURLRequest(url: url! as URL)
        webView.load(requestObj as URLRequest)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (scrollView.contentOffset.y < 0){
            //reach top
            print("\n Reach Top")
            webView.reload()
        }
    }
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
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
