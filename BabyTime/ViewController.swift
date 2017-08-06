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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UserNotificationCenterDelegate.setupReminder(minutes: 1.0/60, body: "Testing 1s")
        
        if let _ = SyncUser.current {
            let realm = try! Realm(configuration: Realms.config())
            
            try! realm.write {
                realm.add(LogEntry())
            }
            performSegue(withIdentifier: "user", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reminder(_ sender: Any) {
//        UserNotificationCenterDelegate.setupReminder(minutes: 0.1, body: "Testing 6s")
        SyncUser.logIn(with: .usernamePassword(username: "pm@cp", password: "pw"),
                       server: URL(string: "http://luxiakun.cn:9080/")!) { (user, error) in
                        print("\(user?.identity) \(error)")
        }
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

