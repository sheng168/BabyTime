//
//  Realms.swift
//  BabyTime
//
//  Created by Jin Yu on 8/6/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation
import RealmSwift

struct Realms {
    #if os(OSX)
    static let syncHost = "127.0.0.1"
    #else
    static let syncHost = "jsy.us" // "localhost" //localIPAddress
    #endif
    
    static let port = 9443
    static let hostPort = "\(syncHost):\(port)"
    
    static let syncRealmPath = "BabyTime"
    
    static let syncServerURL = URL(string: "realms://\(hostPort)/~/\(syncRealmPath)")!
    static let syncAuthURL = URL(string: "https://\(hostPort)")!
    
    static var config = {        
        return Realm.Configuration(
            syncConfiguration: SyncConfiguration(
                user: SyncUser.current!,
                realmURL: syncServerURL)
//            objectTypes: [AppState.self, LogEntry.self]
        )
    }
    
    static var realm = {
        try! Realm(configuration: config())
    }
    
//    static let appID = Bundle.main.bundleIdentifier!

}

final class AppState: Object {
    @objc dynamic var id = ""
    @objc dynamic var time = Date()
    @objc dynamic var timeUploaded: Date? = nil
    @objc dynamic var timeModified: Date? = nil
    
    
    //    @objc dynamic var alarm = true
    
    let babys = List<Baby_>()
    let items = List<LogEntry>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
 }

final class LogEntry: Object {
//    @objc dynamic var id = UUID().uuidString
    @objc dynamic var time = Date()
    @objc dynamic var level = ""
    @objc dynamic var message = ""
    @objc dynamic var timeUploaded: Date? = nil
    @objc dynamic var timeModified: Date? = nil
//    @objc dynamic var alarm = true
    
//    let items = List<Fluid>()
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
