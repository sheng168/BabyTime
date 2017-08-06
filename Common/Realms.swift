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
    static let syncHost = "luxiakun.cn" // "localhost" //localIPAddress
    #endif
    
    static let port = 9080
    static let hostPort = "\(syncHost):\(port)"
    
    static let syncRealmPath = "BabyTime"
    
    static let syncServerURL = URL(string: "realm://\(hostPort)/~/\(syncRealmPath)")!
    static let syncAuthURL = URL(string: "http://\(hostPort)")!
    
    static var config = {        
        return Realm.Configuration(
            syncConfiguration: SyncConfiguration(
                user: SyncUser.current!,
                realmURL: syncServerURL)//, objectTypes: [LogEntry.self]
        )
    }
    
//    static let appID = Bundle.main.bundleIdentifier!

}

final class LogEntry: Object {
//    dynamic var id = UUID().uuidString
    dynamic var time = Date()
    dynamic var level = ""
    dynamic var message = ""
    dynamic var timeUploaded: Date? = nil
    dynamic var timeModified: Date? = nil
//    dynamic var alarm = true
    
//    let items = List<Fluid>()
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
