//
//  RealmModel.swift
//  BabyTime
//
//  Created by Jin Yu on 3/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

import RealmSwift

//let config = Realm.Configuration(objectTypes: [Fluid.self, FluidList.self, Baby.self])
//Realm.Configuration.defaultConfiguration = config

let realm: Realm! = try! realmInit() //try! Realm(configuration: config)
let feeds = realm.objects(Fluid.self).sorted(byKeyPath: "time", ascending: true)

let setting = realm.object(ofType: Setting.self, forPrimaryKey: "1")

func realmInit() throws -> Realm {
//    log.info(config)
    let r = try Realm()

    if r.isEmpty {
        try r.write {
            r.add(Fluid())
        }
    }

    //setDefaultRealmForUser(username: "ios")
    
    return r
}


//    .sorted(by: { (a, b) -> Bool in
//        a.time >= b.time
//    })

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
final class Setting: Object {
    @objc dynamic var id = "1"
    
    @objc dynamic var name = ""
    @objc dynamic var weight = 0.0 // grams
    @objc dynamic var alarm = true
    
    let items = List<Fluid>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Fluid: Object {
    //    @objc dynamic var note = ""
    @objc dynamic var liter = 0.1
    @objc dynamic public var time = Date()
}

extension Fluid: Feed {
    public var amount: Measurement<UnitVolume> {
        return Measurement<UnitVolume>(value: liter, unit: UnitVolume.liters).converted(to: .milliliters)
    }
}

final class FluidList: Object {
    @objc dynamic var type = "milk"
    @objc dynamic var dailyLiters = 1.0
    
    @objc dynamic var interval = 2 * Measurement(value: 1, unit: UnitDuration.hours).converted(to: .seconds).value
    @objc dynamic var perInterval = 0.15
    
    let items = List<Fluid>()
}

final class Baby: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var time = Date()
    
    @objc dynamic var name = ""
    @objc dynamic var weight = 0.0 // grams
    
    let items = List<Fluid>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
