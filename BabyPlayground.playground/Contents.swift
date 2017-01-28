//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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
    var amount: Float = 0.0
//    dynamic
    var time = Date()
    
    init(amount: Float, time: Date = Date()) {
        self.amount = amount
        self.time = time
    }
}

struct Baby {
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60*minute
    
    var feedInterval = 2.5 * hour
    var nextFeed: Date? = Date()
    var nextFeedUpdated: ((_ to: Date) -> Void)? = nil

    var feeds = [
        Feed(amount: 1.5, time: Date(timeIntervalSinceNow: -6*60*60)),
        Feed(amount: 2.0, time: Date(timeIntervalSinceNow: -4*60*60)),
        Feed(amount: 2.5, time: Date(timeIntervalSinceNow: -2*60*60)),
    ]
    
    mutating func feed(_ feed: Feed) {
        feeds.append(feed)
        feeds.sort { (a, b) -> Bool in
            a.time < b.time
        }
        
        nextFeed = feeds.last!.time.addingTimeInterval(feedInterval)
        nextFeedUpdated?(nextFeed!)
    }
    
    mutating func snoozeFeed(by: TimeInterval = 10 * minute) {
        nextFeed? += by
    }
    
}

var alex = Baby()
alex.nextFeedUpdated = {(to: Date) -> Void in
    print("nextFeedUpdated \(to)")
}

alex.feed(Feed(amount: 3.0))

print(alex)
print()
print(alex.feeds.sorted(by: {$0.time > $1.time}))

alex.nextFeed
alex.snoozeFeed()

alex.nextFeed

