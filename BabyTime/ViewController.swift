//
//  ViewController.swift
//  BabyTime
//
//  Created by Jin Yu on 1/16/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserNotificationCenterDelegate.setupReminder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reminder(_ sender: Any) {
        UserNotificationCenterDelegate.setupReminder()
    }

    @IBAction func cloudKitButton(_ sender: Any) {
        let record = CKRecord(recordType: "Feed")
        record["amount"] = 1.5 as CKRecordValue
        record["time"] = Date() as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(record) { [unowned self] record, error in
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

