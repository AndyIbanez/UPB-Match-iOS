//
//  IndividualActivityScoreTableViewController.swift
//  UPB Match
//
//  Created by Andy Ibanez on 12/14/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import UIKit

class IndividualActivityScoreTableViewController: UITableViewController {

    var activity: Activity!
    var participants = [Participant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Activity is: \(self.activity)")
        self.activity.participants({ (participants) -> Void in
            self.participants = participants
            self.tableView.reloadData()
            print("Participants are: \(participants)")
            }) { (error, objects) -> Void in
                print("Error getting participants: \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.participants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let identifier: String
        
        let cell: UITableViewCell
        identifier = "TeamCell"
        cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        let teamNameLabel = cell.viewWithTag(101) as? UILabel
        let pointsEarned = cell.viewWithTag(102) as? UILabel
        let pointsLostLabel = cell.viewWithTag(103) as? UILabel
        let finalPoints = cell.viewWithTag(104) as? UILabel
        
        let team = self.participants[indexPath.row]
            
        print("TeamNameLabel: \(cell.viewWithTag(101))")
        //print("TEAM: \(team.participant.name): \(team.score)")
            
        teamNameLabel?.text = team.participant.name
        pointsEarned?.text = "\(team.totalPoints)"
        pointsLostLabel?.text = "\(team.pointsLost)"
        finalPoints?.text = "\(team.totalPoints - team.pointsLost)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
