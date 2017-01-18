//
//  InterfaceController.swift
//  BabyTimer WatchKit Extension
//
//  Created by Jin Yu on 1/14/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var slider: WKInterfaceSlider!
    
    var amount: Float = 2.0
    
//    static var lastAmount = 1.0
//    static var lastDate = Date()
    
    let amountKey = "amount"
    let dateKey = "date"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        debug(context)
        
        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let amount = userDefaults.float(forKey: amountKey)
        debug(amount)

        // Configure interface objects here.
        setLabelText(amount)
        slider.setValue(amount)
}
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        debug(Feed.list.count)
        for f in Feed.list {
            debug(f)
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
            debug(granted)
            debug(error)
        }
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        // Create the custom actions for the TIMER_EXPIRED category.
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
                                              title: "Stop",
                                              options: .foreground)
        
        let expiredCategory = UNNotificationCategory(identifier: "TIMER_EXPIRED",
                                                     actions: [snoozeAction, stopAction],
                                                     intentIdentifiers: [],
                                                     options: UNNotificationCategoryOptions(rawValue: 0))
        
        // Register the notification categories.
//        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory, expiredCategory])
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        debug(1)
        super.didDeactivate()
    }

    @IBAction func quitMenu() {
        let x:Int? = nil
        print(x!)
    }
    
    @IBAction func feedClick() {
        debug("")

//        amount += 1
//        label.setText("\(amount)")
        timer.setDate(Date())
        timer.start()
        
        Feed.list.append(Feed(amount: amount))
        
        // get the shared instance
        let server = CLKComplicationServer.sharedInstance()
        // extend the timeline for all complications
        for complication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        // Register the category.
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory])
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!",
                                                                arguments: nil)
        
        // Assign the category (and the associated actions).
        content.categoryIdentifier = "TIMER_EXPIRED"
        content.sound = UNNotificationSound.default()
        
        // Create the request and schedule the notification.
        // Configure the trigger for a 7am wakeup.
//        var dateInfo = DateComponents()
//        dateInfo.hour = 15
//        dateInfo.minute = 20
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2*60*60, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
        
        // Schedule the request.
//        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                debug(theError.localizedDescription)
            } else {
                debug(request)
            }
        }
    }
    
    @IBAction func sliderChange(_ value: Float) {
        debug(value)
        //To save the string
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(value, forKey: amountKey)

        setLabelText(value)
        amount = value
    }
    
    func setLabelText(_ value: Float) {
        label.setText("\(value) oz")
    }
}
