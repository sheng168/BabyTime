//
//  ViewController.swift
//  BabyTime
//
//  Created by Jin Yu on 1/16/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import UIKit
import CloudKit
import RealmSwift
import RealmLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UserNotificationCenterDelegate.setupReminder(minutes: 1.0/60, body: "Testing 1s")
        
        if let _ = SyncUser.current {
//            
//            Realm.asyncOpen(configuration: config) { realm, error in
//                if let realm = realm {
//                    // Realm successfully opened, with all remote data available
//                } else if let error = error {
//                    // Handle error that occurred while opening or downloading the contents of the Realm
//                }
//            }

            let realm = try! Realm(configuration: Realms.config())
            
            try! realm.write {
                realm.add(LogEntry())
            }
            
            var state = realm.object(ofType: AppState.self, forPrimaryKey: "")
            if state == nil {
                try! realm.write {
                    state = AppState()
                    realm.add(state!)
                }
            }
            
            AppDelegate.appState = state!
            
            performSegue(withIdentifier: "user", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reminder(_ sender: Any) {
//        UserNotificationCenterDelegate.setupReminder(minutes: 0.1, body: "Testing 6s")
//        SyncUser.logIn(with: .usernamePassword(username: "baby@jsy.us", password: "pw"),
//                       server: Realms.syncAuthURL) { (user, error) in
//                        print("\(String(describing: user?.identity)) \(String(describing: error))")
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "user", sender: self)
//                        }
//
//        }
        
        // Create the object
        let loginController = RealmLoginKit.LoginViewController(style: .lightTranslucent) // init() also defaults to lightTranslucent
        
        // Configure any of the inputs before presenting it
        loginController.serverURL = "https://ros.jsy.us:9443"
        
        // Set a closure that will be called on successful login
        loginController.loginSuccessfulHandler = { user in
            // Provides the successfully authenticated SyncUser object
            print(user)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "user", sender: self)
            }
        }
        
        present(loginController, animated: true)
//        loginController. // loginFail ??
    }

    @IBAction func cloudKitButton(_ sender: Any) {
        let record = CKRecord(recordType: "Feed")
        record["amount"] = 1.5 as CKRecordValue
        record["time"] = Date() as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(record) { /*[unowned self]*/ record, error in
            DispatchQueue.main.async {
                if let error = error {
                    log.error(error)
                } else {
                    log.debug("CloudKit")
                }
                
                //                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
            }
        }
    }
}

