//
//  Feed.swift
//  BabyTime
//
//  Created by Jin Yu on 1/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

class Feed: CustomStringConvertible {
    dynamic var amount: Float = 0.0
    dynamic var time = Date()
    
    init(amount: Float, time: Date = Date()) {
        self.amount = amount
        self.time = time
    }
    
    static var list: [Feed] = [
//        Feed(amount: 0.0),
        Feed(amount: 1, time:Date().addingTimeInterval(-6*60*60)),
        Feed(amount: 2, time:Date().addingTimeInterval(-4*60*60)),
        Feed(amount: 3, time:Date().addingTimeInterval(-2*60*60)),
    ]
    
    public var description: String {
        return "Feed \(amount) \(time)"
    }
}
