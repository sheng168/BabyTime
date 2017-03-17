//
//  RealmModel.swift
//  BabyTime
//
//  Created by Jin Yu on 3/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

import RealmSwift

let config = Realm.Configuration(objectTypes: [Fluid.self])
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

//class Dog: Object {
//    dynamic var name = ""
//    dynamic var age = 0
//}
//class Person: Object {
//    dynamic var name = ""
//    dynamic var picture: NSData? = nil // optionals supported
//    let dogs = List<Dog>()
//}

class Fluid: Object {
    //    dynamic var note = ""
    dynamic var liter = 0.1
    dynamic public var time = Date()
}

extension Fluid: Feed {
    public var amount: Measurement<UnitVolume> {
        return Measurement<UnitVolume>(value: liter, unit: UnitVolume.liters)
    }
}

final class BabyFluidList: Object {
    dynamic var name = ""
    dynamic var id = ""
    dynamic var weightGrams = 0.0
    
    let items = List<Fluid>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
