//
//  SettingsTableViewController.swift
//  Open Sesame
//
//  Created by Ryan Passage on 9/30/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var unlockDelay: UITextField!

    let settings = NSUserDefaults.standardUserDefaults()
    
    var unlockImmediatelyAfterDismissal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
    }
    
    override func viewDidDisappear(animated: Bool) {
        settings.setObject(username.text, forKey: "username")
        settings.setObject(password.text, forKey: "password")
        settings.setObject(unlockDelay.text, forKey: "unlockDelay")
        
        let newUnlockDelay = settings.valueForKey("unlockDelay") as! String
        
        if unlockImmediatelyAfterDismissal {
            // how do we tell the presentingVC to unlock without passing the door around?
        }
        
        print("Updated settings.  Unlock delay is now \(newUnlockDelay).")
    }
    
    func loadSettings() {
        if let username = settings.valueForKey("username") {
            self.username.text = (username as! String)
        }
        
        if let password = settings.valueForKey("password") {
            self.password.text = (password as! String)
        }
        
        if let unlockDelay = settings.valueForKey("unlockDelay") {
            self.unlockDelay.text = unlockDelay as? String
        }
        
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 1
        }
    }
/*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)


        return cell
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
