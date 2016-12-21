//
//  EmergeAPI.swift
//  Open Sesame
//
//  Created by Ryan Passage on 10/8/15.
//  Copyright © 2015 Ryan Passage. All rights reserved.
//

import Foundation
import Alamofire

enum EmergeError: ErrorType {
    case MissingCredentials
    case LoginFailed(String)
    case UnlockFailed
}

class EmergeSession {
    dynamic var isLoggedIn = false
    private let settings = NSUserDefaults.standardUserDefaults()

    private var user: String? {
        return settings.objectForKey("username") as? String
    }
    
    private var password: String? {
       return settings.valueForKey("password") as? String
    }

    private var sessionId: Int?
    private let personIds = [
        "rpassage": 866,
        "wmargolen": 4
    ]
    
    private func login(callback: (success: Bool) -> Void) throws {
        guard let user = self.user, password = self.password else {
            throw EmergeError.MissingCredentials
        }
        
        if isLoggedIn == true {
            callback(success: true)
        }
        
        let payload = [
            "username": user,
            "password": password
        ]
        
        print("login(): logging in...")
        
        let EMERGE_URL = "http://192.168.200.60/frames.asp"

        // process login
        Alamofire.request(.POST, EMERGE_URL, parameters: payload)
            .responseString { [unowned self] (response) -> Void in
                let text = response.result.value
                
                if let range = text?.rangeOfString("(?<=sessionId=)[0-9]+", options: .RegularExpressionSearch) {
                    if let digits = text?.substringWithRange(range) {
                        print("-> successful, sessionId: \(Int(digits)!)")
                        self.sessionId = Int(digits)
                        self.isLoggedIn = true
                        
                        callback(success: true)
                    }
                    else {
                        print(" -> failed, regex didn't find a sessionId")
                        self.isLoggedIn = false
                        
                        callback(success: false)
                    }
                }
                else {
                    print(" -> failed")
                    print(response.debugDescription)

                    self.isLoggedIn = false
                    callback(success: false)
                }
        }
    }
    
    func unlock(door: Door) throws {
     
        do {
            try login { [unowned self] (success) in
                if success {
                    var payload: [String: AnyObject] = [
                        "uid": "F60000002BD7D727",
                        "command_code": 1,
                        "device_id": door.emergeId!,
                        "time": 10,
                        "set_clear": "SET",
                        "db_nodeid": 1,
                        "db_portalid": door.emergeId!
                    ]
                    
                    if let whoami = self.settings.stringForKey("username") {
                        payload.updateValue(self.personIds[whoami]!, forKey: "personid")
                    }
                    else {
                        payload.updateValue(866, forKey: "personid") // default to ryan :\
                    }
                    
                    print("api.unlock: Sending request to unlock \(door.name!) with Emerge ID \(door.emergeId!)")
                    
                    let emergeUnlockUrl = "http://192.168.200.60/goform/ncommandForm?.sessionId=\(self.sessionId!)"
                    
                    print(emergeUnlockUrl)
                    
                    Alamofire.request(.POST, emergeUnlockUrl, parameters: payload)
                        .responseString { (response) in
                            if response.result.isFailure {
                                print("-> unlock failed!")
                                print(response.result.debugDescription)
                                return
                            }
                            
                            print("-> unlocked?")
                    }
                }
                else {
                    print("Can't unlock, login failed")
                }
            }
        }
        catch {
            // asdf
        }

        
    }

}