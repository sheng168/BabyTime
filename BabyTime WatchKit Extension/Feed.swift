//
//  Feed.swift
//  BabyTime
//
//  Created by Jin Yu on 1/17/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import Foundation

class Feed: CustomStringConvertible {
    /// A textual representation of this instance.
    ///
    /// Instead of accessing this property directly, convert an instance of any
    /// type to a string by using the `String(describing:)` initializer. For
    /// example:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `description` property.
    public var description: String {
        return "Feed \(amount) \(time)"
    }

    var amount: Float = 0.0
    var time = Date()
    
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
}
