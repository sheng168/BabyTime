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
    var amount: Measurement<UnitVolume>
//    dynamic
    var time = Date()
    
    init(amount: Measurement<UnitVolume>, time: Date = Date()) {
        self.amount = amount
        self.time = time
    }
}

extension TimeInterval {
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60 * minute
    static let hour1 = Measurement(value: 1, unit: UnitDuration.hours)
}

struct Baby {
    var weight = Measurement(value: 15, unit: UnitMass.pounds)
    var feedInterval = 2.5 * TimeInterval.hour
    
    var nextFeed: Date? = Date()
    var nextFeedUpdated: ((_ to: Date) -> Void)? = nil

    var feeds = [
        Feed(amount: Measurement(value: 90, unit: UnitVolume.milliliters), time: Date(timeIntervalSinceNow: -6 * TimeInterval.hour)),
        Feed(amount: Measurement(value: 120, unit: UnitVolume.milliliters), time: Date(timeIntervalSinceNow: -4 * TimeInterval.hour)),
        Feed(amount: Measurement(value: 180, unit: UnitVolume.milliliters), time: Date(timeIntervalSinceNow: -2 * TimeInterval.hour)),
    ]
    
    var totalAmount: Measurement<UnitVolume> {
        
        let d = Date(timeIntervalSinceNow: feedInterval)
        print(d)
        return feeds.filter { (feed) -> Bool in
            print(feed.time, feed.amount)
            return feed.time < d
        }.reduce(Measurement(value: 0, unit: UnitVolume.milliliters), { (r, feed) -> Measurement<UnitVolume> in
            r + feed.amount
        })
    }
    
    mutating func feed(_ feed: Feed) {
        feeds.append(feed)
        feeds.sort { (a, b) -> Bool in
            a.time < b.time
        }
        
        nextFeed = feeds.last!.time.addingTimeInterval(feedInterval)
        nextFeedUpdated?(nextFeed!)
    }
    
    /// track throw ups
    func puke(_ feed: Feed) {
        
    }
    
    mutating func snoozeFeed(by: TimeInterval = 10 * TimeInterval.minute) {
        nextFeed? += by
    }
    
}

let map = [2: "ok to feed", 2.5: "time to feed", 3: "has baby been sleeping"]
UnitDuration.hours


var alex = Baby()
alex.nextFeedUpdated = {(to: Date) -> Void in
    print("nextFeedUpdated \(to)")
}

alex.feed(Feed(amount: Measurement(value: 180, unit: UnitVolume.milliliters)))

print(alex)
print()
print(alex.feeds.sorted(by: {$0.time > $1.time}))

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

let hour = Measurement(value: 1, unit: UnitDuration.hours)
let sec = hour.converted(to: .seconds)

hour.value
sec.value

alex.totalAmount

extension Double {
    var hour: Measurement<UnitDuration> {
        return Measurement(value: self, unit: UnitDuration.hours)
    }
}

1.hour.customMirror

