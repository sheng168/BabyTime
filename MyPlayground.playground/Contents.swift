//: Playground - noun: a place where people can play

//
//  Feed.swift
//  BabyTime
//
//  Created by Jin Yu on 1/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

//let r = Rec()


extension Measurement where UnitType : UnitDuration {
    var timeInterval: TimeInterval {
//        return (self as! Measurement<UnitDuration>).converted(to: UnitDuration.seconds).value
        return self.converted(to: UnitDuration.seconds as! UnitType).value
    }
}


//let sec = hour.converted(to: .seconds)

//hour.timeInterval
Measurement(value: 1, unit: UnitDuration.seconds).timeInterval




//TimeInterval(hour)



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
print(alex.feedList.sorted(by: {$0.time > $1.time}))

alex.nextFeed
alex.snoozeFeed()

alex.nextFeed

alex.feedList.count

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

alex.totalAmount

extension Double {
    var hour: Measurement<UnitDuration> {
        return Measurement(value: self, unit: UnitDuration.hours)
    }
}

1.hour.customMirror

