//
//  ActivityViewController.swift
//  UPB Match
//
//  Created by Andy Ibanez on 12/14/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import UIKit

typealias Participant = Activity.Participant

class ActivityViewController: UIViewController {
    
    var activity: Activity!
    var activityInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ActivityInfoStoryboardID") as! ActivityInfoTableViewController

    @IBOutlet weak var viewSelectorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let scoreVc = self.childViewControllers.first as! IndividualActivityScoreTableViewController
        scoreVc.activity = self.activity
        self.activityInfoVC.activity = self.activity
        self.viewSelectorSegmentedControl.selectedSegmentIndex = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func selectedViewControllerDidChange(sender: AnyObject) {
        let seg = sender as! UISegmentedControl
        print("selected \(seg.selectedSegmentIndex)")
        if seg.selectedSegmentIndex == 0 {
            // Selected Scores
        } else {
            self.addChildViewController(self.activityInfoVC)
            self.containerView.addSubview(self.activityInfoVC.view)
        }
    }
    
}
