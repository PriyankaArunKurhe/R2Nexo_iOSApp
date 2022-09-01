//
//  MeditationViewController.swift
//  r2
//
//  Created by NonStop io on 21/12/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit
//import SwiftOCR
//import TesseractOCR


class MeditationViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var circleLayer: CAShapeLayer!
    var pause = false
    
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var QuizPreviousButton: UIButton!
    @IBOutlet var circleView: UIView!
    @IBOutlet var innerCircleView1: UIView!
    
    @IBOutlet var capturedImageView: UIImageView!
    
    var pickerController = UIImagePickerController()
    var imageView = UIImage()
    
    var circle2X: CGFloat = 0.0
    var circle2Y: CGFloat = 0.0
    
    
//    let swiftOCRInstance = SwiftOCR()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGradientWithColor(color: UIColor.brown)
        
        self.circleView.addGradientWithColor(color: UIColor.green)
        
        circleView.contentMode = UIView.ContentMode.scaleToFill
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        
        circleView.layer.borderColor = UIColor.lightGray.cgColor
        circleView.layer.borderWidth = 1.0
        
        circle2X = circleView.frame.origin.x
        circle2Y = circleView.frame.origin.y
        
        innerCircleView1.contentMode = UIView.ContentMode.scaleToFill
        innerCircleView1.layer.cornerRadius = innerCircleView1.frame.size.width / 2
        innerCircleView1.clipsToBounds = true
        
        innerCircleView1.layer.borderColor = UIColor.lightGray.cgColor
        innerCircleView1.layer.borderWidth = 1.0
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        self.circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        //        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseOut, animations: {
        //            self.circleView.transform = .identity
        //            self.circleView.backgroundColor = UIColor.black
        //
        //        }, completion: {(isCompleted) in
        //
        //            UIView.animate(withDuration: 4, animations: {
        //                self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        //            }, completion: {(isCompleted) in
        ////                        let circleWidth = self.circleView.frame.size.width
        ////                        let circleHeight = circleWidth
        ////                        let circleView = CircleClosing(frame: CGRect(x: self.circleView.frame.origin.x-2.5, y: self.circleView.frame.origin.y-2.5, width: circleWidth+5, height: circleHeight+5))
        ////                        self.view.addSubview(circleView)
        ////                        circleView.animateCircle(duration: 3.0)
        //
        //            })
        //
        //        })
        
        self.startBreathing()
        
    }
    
    
    
    func startBreathing()  {
        let layer = self.circleView.layer
        //            self.resumeLayer(layer: layer)
        
        self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 4, delay: 0, options: [], animations: {
            self.instructionLabel.alpha = 0
            self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }, completion: {
            finished in
            if finished {
                UIView.animate(withDuration: 4, delay: 0, options: [], animations: {
                    self.instructionLabel.alpha = 1
                    self.circleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    
                }, completion: {
                    finished in
                    if finished {
                        self.startBreathing()
                    }
//                    print("\n complition of animatiom circle 1")
                    
                })
            }
//            print("\n complition of animatiom circle 2")
            self.instructionLabel.alpha = 1
            let circleView = CircleClosing(frame: CGRect(x: self.circle2X-2.5, y: self.circle2Y-2.5, width: 205, height: 205))
            self.view.addSubview(circleView)
            
            circleView.animateCircle(duration: 4.0)
            self.pauseLayer(layer: layer)
            self.instructionLabel.text = "Hold"
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.instructionLabel.text = "Exhale"
                self.resumeLayer(layer: layer)
                
            }
        })
        self.pauseLayer(layer: layer)
        self.instructionLabel.text = "Hold"
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.instructionLabel.text = "Inhale"
            self.resumeLayer(layer: layer)
        }
        
        let circleView = CircleClosing(frame: CGRect(x: self.innerCircleView1.frame.origin.x-2.5, y: self.innerCircleView1.frame.origin.y-2.5, width: 85, height: 85))
        self.view.addSubview(circleView)
        circleView.animateCircle(duration: 4.0)
        
 
    }
    
    
    @IBAction func buttonTouch(_ sender: Any) {
        let layer = self.circleView.layer
        pause = !pause
        if pause {
            pauseLayer(layer: layer)
        } else {
            resumeLayer(layer: layer)
        }
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func captureImageButtonTouch(_ sender: Any) {
        
        openCamera()
        
    }
    
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            self.presentAlertWithOkButton(withTitle: "You don't have camera", message: "")
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView = info[UIImagePickerControllerEditedImage.rawValue] as! UIImage
        capturedImageView.contentMode = .scaleAspectFit
        capturedImageView.image = imageView
        
//        swiftOCRInstance.recognize(capturedImageView.image!) { recognizedString in
//            print("\n capture image OCR string: \(recognizedString)")
//            self.presentAlertWithOkButton(withTitle: "\n capture image OCR string: \(recognizedString)", message: "")
//        }
        
        
        
//        var tesseract:G8Tesseract = G8Tesseract(language:"eng+ita")
//        //tesseract.language = "eng+ita"
//        tesseract.delegate = self
//        tesseract.charWhitelist = "01234567890"
//        tesseract.image = info[UIImagePickerControllerEditedImage] as! UIImage
//        tesseract.recognize()
//        print(tesseract.recognizedText)
//        self.presentAlertWithOkButton(withTitle: "\n capture image OCR string: \(tesseract.recognizedText)", message: "")
        
        dismiss(animated:true, completion: nil)
    }
    
//    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
//        return false // return true if you need to interrupt tesseract before it finishes
//    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated:true, completion: nil)
    }
    
    
    
    @IBAction func backButtonTouch(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
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
