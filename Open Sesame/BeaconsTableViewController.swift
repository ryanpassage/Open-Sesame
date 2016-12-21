//
//  BeaconsTableViewController.swift
//  Open Sesame
//
//  Created by Ryan Passage on 9/25/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import UIKit
import CoreLocation


class BeaconsTableViewController: UITableViewController {
    let beaconManager = BeaconManager.sharedInstance
    var api = EmergeSession()
    var lastUnlock: NSDate?
    var settings = NSUserDefaults.standardUserDefaults()
    
    let doors = [
        Door(major: 15262, emergeId: 2, name: "Steel Server Room")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconManager.addObserver(self, forKeyPath: "beacons", options: .New, context: nil)
    }
    
    deinit {
        beaconManager.removeObserver(self, forKeyPath: "beacons")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "beacons" {
            tableView.reloadData()
            
            for beacon in beaconManager.beacons {
                if beacon.proximity.stringValue == "Near" {
                    let door = doors.filter { (e: Door) in e.beaconMajor == beacon.major.integerValue }
                    unlockDoor(door.first!)
                }
            }
        }
    }
    
    func unlockDoor(door: Door, now: Bool = false) {
        //print("unlockDoor: \(door.name!)")
        
        if now {
            do {
                try api.unlock(door)
                lastUnlock = NSDate()

                let notification = UILocalNotification()
                notification.alertBody = "Sent unlock signal to \(door.name) door."
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
            catch {
                let settingsVC = SettingsTableViewController()
                settingsVC.unlockImmediatelyAfterDismissal = true
                presentViewController(settingsVC, animated: true, completion: nil)
            }
        }

        if let prevUnlock = lastUnlock {
            let secondsSinceLastUnlock = abs(Int(prevUnlock.timeIntervalSinceDate(NSDate())))
            let unlockDelay = settings.valueForKey("unlockDelay") as? Int ?? 10
            
            if Int(secondsSinceLastUnlock) >= unlockDelay {
                unlockDoor(door, now: true)
            }
            else {
                print("\(secondsSinceLastUnlock) seconds since last unlock.  Need to wait \(unlockDelay - secondsSinceLastUnlock) more seconds.")
            }
        }
        else {
            // lastUnlock was nil, so this is our first time running the app (I guess).  unlock the door now and set a new value
            unlockDoor(door, now: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaconManager.beacons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PortalTableViewCell
        
        let beacon = beaconManager.beacons[indexPath.row]
        
        for door in doors {
            if door.beaconMajor == beacon.major.integerValue {
                // Configure the cell...
                cell.name.text = door.name!
                cell.distance.text = beacon.proximity.stringValue
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "Searching for doors..."
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        let stack = UIStackView(arrangedSubviews: [header, spinner])
        stack.axis = .Horizontal
        stack.distribution = .Fill
        stack.spacing = 5
        
        return stack
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}





