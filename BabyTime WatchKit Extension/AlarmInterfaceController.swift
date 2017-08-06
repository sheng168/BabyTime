//
//  AlarmController.swift
//  BabyTime
//
//  Created by Jin Yu on 3/18/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation
import WatchKit
import Foundation
//import RealmSwift

class AlarmInterfaceController: WKInterfaceController {
    
    @IBAction func testAction() {
        UserNotificationCenterDelegate.setupReminder(minutes: 0.1, body: "Testing")
    }
}
