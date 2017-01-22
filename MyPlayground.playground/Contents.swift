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
    
    static var list: [Feed] = [
        //        Feed(amount: 0.0),
        Feed(amount: 1.5, time: Date(timeIntervalSinceNow: -6*60*60)),
        Feed(amount: 2.0, time: Date(timeIntervalSinceNow: -4*60*60)),
        Feed(amount: 2.5, time: Date(timeIntervalSinceNow: -2*60*60)),
        ]
    
//    public var description: String {
//        return "Feed \(amount) \(time)"
//    }
}

struct Baby {
    var feeds = [Feed]()
    
}

var alex = Baby()
alex.feeds.append(contentsOf: Feed.list)

print(alex)