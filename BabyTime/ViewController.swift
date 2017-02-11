//
//  ViewController.swift
//  BabyTime
//
//  Created by Jin Yu on 1/16/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import UIKit

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

}

