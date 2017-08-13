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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    @IBAction func loginClicked() {
//        SyncUser.current.
        SyncUser.logIn(with: .usernamePassword(username: "baby@jsy.us", password: "pw"), server: Realms.syncAuthURL) { (user, err) in
            print(user, err)
            guard let _ = user else {
                return
            }
            
            Realm.Configuration.defaultConfiguration = Realms.config()
            Realm.asyncOpen(callback: { (realm, err) in
                print(realm, err)
                
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
