//
//  UserNotificationCenterDelegate.swift
//  BabyTime
//
//  Created by Jin Yu on 1/18/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import UserNotifications

var current: WKInterfaceController?

class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let instance = UserNotificationCenterDelegate()
//    static let categoryGeneral = "general"
//    static let categoryTimer = "now"
//    static let actionSnooze = "SNOOZE_ACTION"
//    static let actionDone = "STOP_ACTION"
    
    enum Category: String {
        case general
        case timer
    }
    
    enum Action: String {
        case snooze
        case stop
        case now
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log.info("willPresent")
        log.info(notification)
        
//        current?.presentAlert(withTitle: "",
//                              message: "",
//                              preferredStyle: .actionSheet,
//                              actions: [])
         
        
        completionHandler([.alert, .sound, .badge])
//        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        log.info("didReceive")
        log.info(response)
        
        
        switch response.actionIdentifier {
        case Action.snooze.rawValue:
            log.info(Action.snooze)
        default:
            log.error("*** missing case *** \(response.actionIdentifier)")
        }
        completionHandler()
    }
    
    static func register() {
        #if os(iOS)
            debug("iOS")
        #else
            debug("watchOS")
        #endif
        
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
                let snoozeAction = UNNotificationAction(identifier: Action.snooze.rawValue,
                                                        title: "Snooze",
                                                        options: UNNotificationActionOptions(rawValue: 0))
                let stopAction = UNNotificationAction(identifier: Action.stop.rawValue,
                                                      title: "Stop",
                                                      options: .foreground)
                let commentAction = UNTextInputNotificationAction(
                    identifier: "comment",
                    title: "Comment",
                    options: [],
                    textInputButtonTitle: "Send",
                    textInputPlaceholder: "Type here...")
                
                let expiredCategory = UNNotificationCategory(identifier: Category.timer.rawValue,
                                                             actions: [snoozeAction, stopAction, commentAction],
                                                             intentIdentifiers: [],
                                                             options: [.customDismissAction])
                
                let generalCategory = UNNotificationCategory(identifier: Category.general.rawValue,
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

    static func setupReminder(minutes: Double, body: String, id: String = UUID().uuidString) {
        debug(minutes)
        if minutes <= 0 {
            log.warning("no")
            return
        }
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
        content.body = body //NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        
        // Assign the category (and the associated actions).
        content.categoryIdentifier = Category.timer.rawValue
        content.sound = UNNotificationSound.default()
        
        // Create the request and schedule the notification.
        // Configure the trigger for a 7am wakeup.
        #if swift(>=3)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: minutes*60, repeats: false)
        #else
            *
            var dateInfo = DateComponents()
            dateInfo.hour = 21
            dateInfo.minute = 05
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        #endif
        
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
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
