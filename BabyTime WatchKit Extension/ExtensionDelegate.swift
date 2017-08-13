//
//  ExtensionDelegate.swift
//  BabyTimer WatchKit Extension
//
//  Created by Jin Yu on 1/14/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
//import KeychainSwift
//import SwiftyBeaver
import RealmSwift

//let log = logger()



class ExtensionDelegate: NSObject, WKExtensionDelegate {
    var token: NotificationToken?
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.

//        SyncUser.logIn(with: .usernamePassword(username: "r@j", password: "Catch150"), server: URL(string: "https://jsy.us:9443")!) { (user, err) in
//            print(user, err)
//        }
//        debug(1)
        log.debug(feeds.count)
        
        log.debug(feeds.count)
        token = feeds.addNotificationBlock { (changes: RealmCollectionChange<Results<Fluid>>) in
            log.info("RealmFeed updated")
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                log.info("RealmFeed initial")
                break
            case .update(let t, let deletions, let insertions, let modifications):
                log.info("RealmFeed update: \(t.count) d\(deletions) i\(insertions) m\(modifications)")
                
                if insertions.count > 0 && insertions[0] == t.count-1 {
                    // data appended
                    let f = t[insertions[0]]
                    
                    func genReminder(_ i: Int) {
                        let interval = f.time.addingTimeInterval(Double(i)*60.0).timeIntervalSinceNow
                        let hr = i / 60
                        let min = i % 60
                        let body = "Last feeding was \(hr)H \(min)M ago"
                        UserNotificationCenterDelegate.setupReminder(minutes: interval/60.0, body: body, id: body)
                    }
                    
//                    genReminder(1)
                    
                    for i in stride(from:60, to:120, by:60) {
                        genReminder(i)
                    }
                    for i in stride(from:120, to:360, by:15) {
                        genReminder(i)
                    }
                    for i in stride(from:360, through:720, by:30) {
                        genReminder(i)
                    }
                }
                // Query results have changed, so apply them to the UITableView
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                     with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .automatic)
//                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                log.error("RealmFeed error: \(error)")
                break
            }
            
        }
        
//        SyncSession.

        UserNotificationCenterDelegate.register()
//        _ = realmInit()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        debug(2)
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        debug(-2)
    }

//    @available(watchOSApplicationExtension 3.0, *)
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        debug(backgroundTasks.count)
        
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }

}
