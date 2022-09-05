//
//  ViewMoreViewController.swift
//  r2
//
//  Created by NonStop io on 31/10/17.
//  Copyright © 2017 NonStop io. All rights reserved.
//

import UIKit

class ViewMoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var commentTableView: UITableView!
    @IBOutlet var commentTableViewHeightOutlet: NSLayoutConstraint!
    @IBOutlet var feedsImageViewHeightOutlet: NSLayoutConstraint!
    @IBOutlet var feedDescTextView: UITextView!
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        let screenSize: CGRect = UIScreen.main.bounds
        //        feedImageView.frame = CGRect(x: 10, y: feedDescTextView.frame.origin.y+feedDescTextView.frame.size.height+10, width: screenSize.width-10, height: screenSize.width-10)
        feedsImageViewHeightOutlet.constant = 300.0
        
        //        commentTableView.frame = CGRect(x: commentTableView.frame.origin.x, y: commentTableView.frame.origin.y, width: commentTableView.frame.size.width, height: commentTableView.contentSize.height)
        
        commentTableViewHeightOutlet.constant = commentTableView.contentSize.height
        self.commentTableView.scrollToRow(at: IndexPath (row:99,section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table View
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        if indexPath.row % 2 == 0 {
            cell.commenterNameLabel.text = "Rauf Shaikh"
            cell.commentTextLabel.text = "ttttu"
            
        }else{
            cell.commenterNameLabel.text = "Arnold Parge"
            cell.commentTextLabel.text = "quis nostrud exercconscient to factor tum poen legum odioque civiuda.  Lorem ipsum dolor sit er m adipisicing pecu, sed do eiu"
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
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
