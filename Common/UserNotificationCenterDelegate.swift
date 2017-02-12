//
//  UserNotificationCenterDelegate.swift
//  BabyTime
//
//  Created by Jin Yu on 1/18/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

//import WatchKit
import UserNotifications

class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let instance = UserNotificationCenterDelegate()
    static let categoryGeneral = "GENERAL"
    static let categoryTimer = "TIMER_EXPIRED"
    static let actionSnooze = "SNOOZE_ACTION"
    static let actionDone = "STOP_ACTION"
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debug(notification)
        
        completionHandler([.alert, .sound, .badge])
//        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debug(response)
        
        
        switch response.actionIdentifier {
        case UserNotificationCenterDelegate.actionSnooze:
            debug(UserNotificationCenterDelegate.actionSnooze)
        default:
            debug("*** missing case ***")
        }
        completionHandler()
    }
    
    static func register() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization
            debug(granted)
            debug(error)
            
            center.getNotificationSettings(completionHandler: { (settings) in
                debug(settings)
                debug(settings.alertSetting)
            })
            
            if granted {
                // Create the custom actions for the TIMER_EXPIRED category.
                let snoozeAction = UNNotificationAction(identifier: actionSnooze,
                                                        title: "Snooze",
                                                        options: UNNotificationActionOptions(rawValue: 0))
                let stopAction = UNNotificationAction(identifier: actionDone,
                                                      title: "Stop",
                                                      options: .foreground)
                let commentAction = UNTextInputNotificationAction(
                    identifier: "comment",
                    title: "Comment",
                    options: [],
                    textInputButtonTitle: "Send",
                    textInputPlaceholder: "Type here...")
                
                let expiredCategory = UNNotificationCategory(identifier: categoryTimer,
                                                             actions: [snoozeAction, stopAction, commentAction],
                                                             intentIdentifiers: [],
                                                             options: [.customDismissAction])
                
                let generalCategory = UNNotificationCategory(identifier: categoryGeneral,
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
                // Register the notification categories.
                //        let center = UNUserNotificationCenter.current()
                center.setNotificationCategories([generalCategory, expiredCategory])
                center.delegate = instance

            }
        }
        
    }

    static func setupReminder() {
        debug(1)
//        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
//                                                     actions: [],
//                                                     intentIdentifiers: [],
//                                                     options: .customDismissAction)
        
        // Register the category.
        let center = UNUserNotificationCenter.current()
//        center.setNotificationCategories([generalCategory])
        
        let content = UNMutableNotificationContent()
        content.title = "It's time" //NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.subtitle = "subtitle"
        content.body = "Ready for feeding" //NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        
        // Assign the category (and the associated actions).
        content.categoryIdentifier = categoryTimer
        content.sound = UNNotificationSound.default()
        
        // Create the request and schedule the notification.
        // Configure the trigger for a 7am wakeup.
        #if swift(>=3)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1/*60*60*/, repeats: false)
        #else
            var dateInfo = DateComponents()
            dateInfo.hour = 21
            dateInfo.minute = 05
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        #endif
        
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
//        request.
        
        // Schedule the request.
        //        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                debug(theError.localizedDescription)
            } else {
//                debug(request)
//                debug(center.delegate)
            }
        }

    }
}
