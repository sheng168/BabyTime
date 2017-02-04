//: Playground - noun: a place where people can play

//
//  Feed.swift
//  BabyTime
//
//  Created by Jin Yu on 1/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

struct Feed //: CustomStringConvertible
{
//    dynamic
    let amount: Measurement<UnitVolume>
//    dynamic
    let date: Date
    
    init(amount: Measurement<UnitVolume>, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}

extension Measurement where UnitType : UnitDuration {
    var timeInterval: TimeInterval {
//        return (self as! Measurement<UnitDuration>).converted(to: UnitDuration.seconds).value
        return self.converted(to: UnitDuration.seconds as! UnitType).value
    }
}


let hour = Measurement(value: 1, unit: UnitDuration.hours)
let sec = hour.converted(to: .seconds)

hour.timeInterval
Measurement(value: 1, unit: UnitDuration.seconds).timeInterval

extension TimeInterval {
    init(_ dur: Measurement<UnitDuration>) {
        self.init(dur.converted(to: UnitDuration.seconds).value)
    }
    
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60 * minute
    static let hour1 = Measurement(value: 1, unit: UnitDuration.hours)
}



TimeInterval(hour)

struct Baby {
    var weight = Measurement(value: 15, unit: UnitMass.pounds)
    var feedInterval = 2.5 * hour
    
    var nextFeed: Date? = Date()
    var nextFeedUpdated: ((_ to: Date) -> Void)? = nil

    var feeds = //[Feed]()
    [
        Feed(amount: Measurement(value: 90, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -6 * TimeInterval.hour)),
        Feed(amount: Measurement(value: 120, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -4 * TimeInterval.hour)),
        Feed(amount: Measurement(value: 180, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -2 * TimeInterval.hour)),
    ]
    
    var totalAmount: Measurement<UnitVolume> {
        
        let d = Date(timeIntervalSinceNow: feedInterval.converted(to: UnitDuration.seconds).value)
//        print(d)
        return feeds.filter { (feed) -> Bool in
            print(feed.date, feed.amount)
            return feed.date < d
        }.reduce(Measurement(value: 0, unit: UnitVolume.milliliters), { (r, feed) -> Measurement<UnitVolume> in
            r + feed.amount
        })
    }
    
    mutating func feed(_ feed: Feed) {
        feeds.append(feed)
        feeds.sort { (a, b) -> Bool in
            a.date < b.date
        }
        
        nextFeed = feeds.last!.date.addingTimeInterval(feedInterval.converted(to: UnitDuration.seconds).value)
        nextFeedUpdated?(nextFeed!)
    }
    
    /// track throw ups
    func puke(_ feed: Feed) {
        
    }
    
    mutating func snoozeFeed(by: TimeInterval = 10 * TimeInterval.minute) {
        nextFeed? += by
    }
    
}

let map = [
    2: "ok to feed",
    2.5: "time to feed",
    3: "has baby been sleeping",
    4: "did you forget to enter feeding record",
    6: "did you forget to enter feeding record",
]

let feedReminderOptions = ["Feed", "Snooze x", "Dismiss"]

UnitDuration.hours


var alex = Baby()
alex.nextFeedUpdated = {(to: Date) -> Void in
    print("nextFeedUpdated \(to)")
}

alex.feed(Feed(amount: Measurement(value: 180, unit: UnitVolume.milliliters)))

print(alex)
print()
print(alex.feeds.sorted(by: {$0.date > $1.date}))

alex.nextFeed
alex.snoozeFeed()

alex.nextFeed

alex.feeds.count

alex.totalAmount

let oz = Measurement(value: 2, unit: UnitVolume.fluidOunces)
let ml = Measurement(value: 60, unit: UnitVolume.milliliters)

oz + ml
ml.converted(to: .fluidOunces).converted(to: .milliliters)
oz.converted(to: .milliliters)

oz
ml

let form = MeasurementFormatter()
form.unitOptions = [.providedUnit]

form.string(from: ml)
form.string(from: oz)


hour.value
sec.value

alex.totalAmount

extension Double {
    var hour: Measurement<UnitDuration> {
        return Measurement(value: self, unit: UnitDuration.hours)
    }
}

1.hour.customMirror

