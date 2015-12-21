//
//  CalendarTableViewController.swift
//  UPB Match
//
//  Created by Andy Ibanez on 12/20/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import UIKit

class CalendarTableViewController: UITableViewController {

    //var events = [Event]() // All events
    var monthEvents = [[Event]]()
    var monthCounter = 0
    var availableMonths = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        Event.fetchEvents({ (events) -> Void in
            //self.events = events
            for m in 1...12 {
                let evs = events.filter({ (ev) -> Bool in
                    return ev.month == m
                })
                if evs.count > 0 {
                    let month: String
                    switch m {
                    case 1: month = "Enero"
                    case 2: month = "Febrero"
                    case 3: month = "Marzo"
                    case 4: month = "Abril"
                    case 5: month = "Mayo"
                    case 6: month = "Junio"
                    case 7: month = "Julio"
                    case 8: month = "Agosto"
                    case 9: month = "Septiembre"
                    case 10: month = "Octubre"
                    case 11: month = "Noviembre"
                    case 12: month = "Diciembre"
                    default: fatalError()
                    }
                    
                    print("month \(month) \(evs.count) events")
                    
                    self.availableMonths += [month]
                    self.monthEvents += [evs]
                }
            }
            /*for event in self.events {
                if self.monthEvents[event.month].isEmpty {
                    self.monthEvents[event.month] = [event]
                    
                    let month: String
                    switch event.month {
                    case 1: month = "Enero"
                    case 2: month = "Febrero"
                    case 3: month = "Marzo"
                    case 4: month = "Abril"
                    case 5: month = "Mayo"
                    case 6: month = "Junio"
                    case 7: month = "Julio"
                    case 8: month = "Agosto"
                    case 9: month = "Septiembre"
                    case 10: month = "Octubre"
                    case 11: month = "Noviembre"
                    case 12: month = "Diciembre"
                    default: fatalError()
                    }
                    
                    self.availableMonths += [month]
                } else {
                    self.monthEvents[event.month]! += [event]
                }
            }*/
            print("month events \(self.monthEvents) available months \(self.availableMonths)")
            self.tableView.reloadData()
            }) { (error, events) -> Void in
                print("Fuck me \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.availableMonths.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.availableMonths[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        /*print("section is \(section)")
        let sortedKeys = Array(self.monthEvents.keys).sort(<)
        let current = self.monthCounter
        if current != sortedKeys.count - 1 {
            self.monthCounter += 1
        }
        print("Sorted keys \(sortedKeys) and current \(current) and sorted keys \(sortedKeys[current])")
        return self.monthEvents[sortedKeys[current]]!.count*/
        return self.monthEvents[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let event = self.monthEvents[indexPath.section][indexPath.row]
        /*let sortedKeys = Array(self.monthEvents.keys).sort(<)
        let current = self.monthCounter
        print("the index path row \(indexPath.row)")
        let event = self.monthEvents[sortedKeys[current]]![0]

        // Configure the cell..."*/
        let date = cell.viewWithTag(100) as! UILabel
        date.text = "\(event.day)"
        
        let title = cell.viewWithTag(101) as! UILabel
        title.text = event.name
        
        let desc = cell.viewWithTag(102) as! UITextView
        desc.text = event.description
        
        let hour = cell.viewWithTag(103) as! UILabel
        hour.text = event.hour

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
