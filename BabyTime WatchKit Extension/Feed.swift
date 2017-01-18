//
//  Feed.swift
//  BabyTime
//
//  Created by Jin Yu on 1/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

class Feed {
    var amount: Float = 0.0
    var time = Date()
    
    init(amount: Float, time: Date = Date()) {
        self.amount = amount
    }
    
    static var list: [Feed] = [
//        Feed(amount: 0.0),
        Feed(amount: 1, time:Date().addingTimeInterval(-6*60*60)),
        Feed(amount: 2, time:Date().addingTimeInterval(-4*60*60)),
        Feed(amount: 3, time:Date().addingTimeInterval(-2*60*60)),
    ]
}
