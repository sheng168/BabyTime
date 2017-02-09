import Foundation

public struct Rec //: CustomStringConvertible
{
    //    dynamic
    let date: Date
    
    public init(date: Date = Date()) {
//        self.amount = amount
        self.date = date
    }
}

public struct Feed //: CustomStringConvertible
{
    //    dynamic
    public let amount: Measurement<UnitVolume>
    //    dynamic
    public let date: Date
    
    public init(amount: Measurement<UnitVolume>, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
}

let hour = Measurement(value: 1, unit: UnitDuration.hours)
extension TimeInterval {
    init(_ dur: Measurement<UnitDuration>) {
        self.init(dur.converted(to: UnitDuration.seconds).value)
    }
    
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = 60 * minute
    static let hour1 = Measurement(value: 1, unit: UnitDuration.hours)
}

public struct Baby {
    public var weight = Measurement(value: 15, unit: UnitMass.pounds)
    public var feedInterval = 2.5 * hour
    
    public var nextFeed: Date? = Date()
    public var nextFeedUpdated: ((_ to: Date) -> Void)? = nil
    
    public init(){} // any way to just make default public?
    
    public var feeds = //[Feed]()
        [
            Feed(amount: Measurement(value: 90, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -6 * TimeInterval.hour)),
            Feed(amount: Measurement(value: 120, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -4 * TimeInterval.hour)),
            Feed(amount: Measurement(value: 180, unit: UnitVolume.milliliters), date: Date(timeIntervalSinceNow: -2 * TimeInterval.hour)),
            ]
    
    public var totalAmount: Measurement<UnitVolume> {
        
        let d = Date(timeIntervalSinceNow: feedInterval.converted(to: UnitDuration.seconds).value)
        //        print(d)
        return feeds.filter { (feed) -> Bool in
            print(feed.date, feed.amount)
            return feed.date < d
            }.reduce(Measurement(value: 0, unit: UnitVolume.milliliters), { (r, feed) -> Measurement<UnitVolume> in
                r + feed.amount
            })
    }
    
    public mutating func feed(_ feed: Feed) {
        feeds.append(feed)
        feeds.sort { (a, b) -> Bool in
            a.date < b.date
        }
        
        nextFeed = feeds.last!.date.addingTimeInterval(feedInterval.converted(to: UnitDuration.seconds).value)
        nextFeedUpdated?(nextFeed!)
    }
    
    /// track throw ups
    public func puke(_ feed: Feed) {
        
    }
    
    public mutating func snoozeFeed(by: TimeInterval = 10 * TimeInterval.minute) {
        nextFeed? += by
    }
    
}
