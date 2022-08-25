//
//  ZoomImageViewController.swift
//  r2
//
//  Created by NonStop io on 14/11/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController {
    @IBOutlet var zoomImageScrollView: ImageScrollView!
    var imageName: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let myImage = UIImage(named:imageName as String)!
        self.view.backgroundColor = UIColor.clear
        zoomImageScrollView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeZoomImagevView(_:)))
        singleTap.numberOfTapsRequired = 1
        zoomImageScrollView.addGestureRecognizer(singleTap)
        self.navigationController?.toolbar.backgroundColor = UIColor.clear
//        zoomImageScrollView.display(image: myImage)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeZoomImagevView(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
    @objc func TapToCloseZoomVwCtrlr(_ sender: UITapGestureRecognizer) {
        self.view.removeFromSuperview()
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
