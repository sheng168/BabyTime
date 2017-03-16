//
//  ExtensionDelegate.swift
//  BabyTimer WatchKit Extension
//
//  Created by Jin Yu on 1/14/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
//import KeychainSwift
import SwiftyBeaver
import RealmSwift

let log = logger()

let config = Realm.Configuration(objectTypes: [RealmFeed.self, Dog.self, Person.self])
var realm: Realm! = try! Realm(configuration: config)

//func realmInit() -> Realm? {
//    log.info("login")
//    let cred = SyncCredentials.usernamePassword(username: "user", password: "password")
//    
//    SyncUser.logIn(with: cred, server: URL(string: "realm://localhost:9080/~/userRealm")!) { (user, error) in
//        if let user = user {
//            // Create the configuration
//            let syncServerURL = URL(string: "realm://localhost:9080/~/userRealm")!
//            let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL))
//            
//            // Open the remote Realm
//            realm = try! Realm(configuration: config)
//        } else if let error = error {
//            log.error(error)
//        }
//    }
//    
//    return nil
//}

class Dog: Object {
    dynamic var name = ""
    dynamic var age = 0
}
class Person: Object {
    dynamic var name = ""
    dynamic var picture: NSData? = nil // optionals supported
    let dogs = List<Dog>()
}

public class RealmFeed: Object {
    dynamic var note = ""
    dynamic var amount = 0.0
    dynamic var time = Date()
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    var token: NotificationToken?
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.

//        debug(1)
        log.debug(baby.feedList.count)
        
        
        // Use them like regular Swift objects
        let myDog = Dog()
        myDog.name = "Rex"
        myDog.age = 1
        print("name of dog: \(myDog.name)")
        
        // Get the default Realm
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog.self) //.filter("age < 2")
        log.debug(puppies.count) // => 0 because no dogs have been added to the Realm yet
        
        // Persist your data easily
        try! realm.write {
            realm.add(myDog)
        }
        
        // Queries are updated in realtime
        log.debug(puppies.count) // => 1
        for (i, d) in puppies.enumerated() {
            log.debug("\(i) \(d)")
        }
        
        let feeds = realm.objects(RealmFeed.self)
        log.debug(feeds.count)
        token = feeds.addNotificationBlock { (changes: RealmCollectionChange<Results<RealmFeed>>) in
            log.info("RealmFeed updated")
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                log.info("RealmFeed initial")
                break
            case .update(let t, let deletions, let insertions, let modifications):
                log.info("RealmFeed update: \(t.count) d\(deletions) i\(insertions) m\(modifications)")
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
        
        SyncSession.

        // Query and update from any thread
        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            let theDog = realm.objects(Dog.self).filter("age == 1").first
            try! realm.write {
                theDog!.age = 3
            }
        }
//        let keychain = KeychainSwift()
//        keychain.set("hello world", forKey: "my key")
//        
//        let key = keychain.get("my key")
//        debug(key)
//        keychain.delete("my key")
        
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

    @available(watchOSApplicationExtension 3.0, *)
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
