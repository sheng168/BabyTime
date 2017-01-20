//
//  UserNotificationCenterDelegate.swift
//  BabyTime
//
//  Created by Jin Yu on 1/18/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import UserNotifications

class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    static func register() {
        
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
        center.delegate = UserNotificationCenterDelegate()
    }

    static func setupReminder() {
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
        #if swift(>=3)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2*6/*0*60*/, repeats: false)
        #else
            var dateInfo = DateComponents()
            dateInfo.hour = 21
            dateInfo.minute = 05
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        #endif
        
        
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
}
