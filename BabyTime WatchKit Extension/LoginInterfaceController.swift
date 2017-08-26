//
//  LoginInterfaceController.swift
//  BabyTime WatchKit Extension
//
//  Created by Jin Yu on 8/12/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class LoginInterfaceController: WKInterfaceController {
    @IBOutlet var loginButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if SyncUser.current != nil {
            Realm.Configuration.defaultConfiguration = Realms.config()
            pushController(withName: "list", context: nil)
            return
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    @IBAction func loginClicked() {
        if SyncUser.current != nil {
            Realm.Configuration.defaultConfiguration = Realms.config()
            pushController(withName: "list", context: nil)
            return
        }
        
        loginButton.setEnabled(false)
        SyncUser.logIn(with: .usernamePassword(username: "baby@jsy.us", password: "pw"),
                       server: Realms.syncAuthURL) { (user, err) in
                        print(user as Any, err as Any)
            guard let _ = user else {
                self.loginButton.setEnabled(true)
                return
            }
            
            Realm.Configuration.defaultConfiguration = Realms.config()
            Realm.asyncOpen(callback: { (realm, err) in
                print(realm as Any, err as Any)
                self.loginButton.setEnabled(true)
                self.pushController(withName: "list", context: nil)
            })

            print(Realm.Configuration.defaultConfiguration)
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        log.debug(segueIdentifier)
        
        return nil
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }    
}
