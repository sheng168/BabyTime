//
//  ComplicationController.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import ClockKit
//import os.log

extension CLKComplicationFamily: CustomStringConvertible {
    public var description: String {
        switch self {
        case .modularSmall:
            return "modularSmall"
        case .modularLarge:
            return "modularLarge"
            
            //        case .utilitarianSmall:
            //            template = utilitarianSmall(bill)
            //        case .utilitarianLarge:
            //            template = utilitarianLarge(bill)
            //        case .circularSmall:
            //            template = circularSmall(bill)
            //        case .utilitarianSmallFlat:
            //            template = utilitarianSmall(bill)
        //        case.extraLarge:
        default:
            return "CLKComplicationFamily \(self.rawValue))"
            
        }

    }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        log.verbose(complication.family)

//        handler(CLKComplicationTimeTravelDirections())
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        log.verbose(complication.family)
        let start = feeds.first!.time //Date().addingTimeInterval(-100*60)
            
        handler(start)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        log.verbose(complication.family)
        let end = feeds.last!.time.addingTimeInterval(60*60*3) //Date().addingTimeInterval(100*60)
        handler(end)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        log.verbose(complication.family)
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (@escaping (CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        log.verbose(complication.debugDescription)
        
        let templ = getTemplateForComplication(complication, feeds.last!)
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templ)
            
        handler(entry)
    }
    
    func getTimelineEntry(_ complication: CLKComplication,_ feed: Feed) -> CLKComplicationTimelineEntry {
        return CLKComplicationTimelineEntry(date: feed.time, complicationTemplate: getTemplateForComplication(complication, feed))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        log.verbose("\(complication.family) \(date) \(limit)")
        
        var array = [CLKComplicationTimelineEntry]()
        
        for f in feeds.reversed() {
            if date.compare(f.time) == .orderedDescending {
                array.append(getTimelineEntry(complication, f))
                if array.count >= limit {
                    break
                }
            }
        }
        handler(array)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        log.verbose("\(complication.family) \(date) \(limit)")
        
        var array = [CLKComplicationTimelineEntry]()
        
        for f in feeds {
            if date.compare(f.time) == .orderedAscending {
                array.append(getTimelineEntry(complication, f))
                if array.count >= limit {
                    break
                }
            }
        }
        handler(array)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        log.verbose("")
        //        handler(nil)
        handler(Date(timeIntervalSinceNow: 60*60))
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
//        log.verbose("family:\(complication.family) \(complication.family.description)")
        log.verbose(complication.family)

        let template: CLKComplicationTemplate? = getTemplateForComplication(complication,
                                                                            FeedStruct(amount: Measurement(value: -2, unit: UnitVolume.fluidOunces)))
        handler(template)
    }
    
    // MARK: - Generate Templates
    
    func getTemplateForComplication(_ complication: CLKComplication,_ feed: Feed) -> CLKComplicationTemplate {
        // This method will be called once per supported complication, and the results will be cached
        log.verbose(complication.family)
        log.verbose(feed)
        
        let template: CLKComplicationTemplate
        
        switch complication.family {
        case .modularSmall:
            template = modularSmall(feed)
        case .modularLarge:
            template = modularLarge(feed)
            
        case .utilitarianSmall:
            template = utilitarianSmall(feed)
        case .utilitarianLarge:
            template = utilitarianLarge(feed)
            
        case .circularSmall:
            template = circularSmall(feed)
        case .utilitarianSmallFlat:
            template = utilitarianSmall(feed)
            
        case.extraLarge:
//        default:
            let t = CLKComplicationTemplateExtraLargeSimpleText()
            t.textProvider = relativeDate(feed)
            template = t
            
        }
        
        return (template)
    }
    
    func time(_ f: Feed) -> CLKTextProvider {
        let tp = CLKTimeTextProvider(date: f.time)
        return tp
    }
    
    func relativeDate(_ f: Feed) -> CLKTextProvider {
        let tp = CLKRelativeDateTextProvider(date: f.time, style: .natural, units: [.day, .hour, .minute, .second])
        return tp
    }
    
    fileprivate func modularSmall(_ f: Feed) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "\(f.amount)", shortText: "\(f.amount.value)")
        t.line2TextProvider = relativeDate(f)
        return t
        
    }
    
    fileprivate func modularLarge(_ f: Feed) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularLargeStandardBody()
        let oz = String(format: "%.1f", f.amount.converted(to: UnitVolume.fluidOunces).value)
        
        t.headerTextProvider = CLKSimpleTextProvider(text: "\(f.amount) \(oz) oz")
        t.body1TextProvider = relativeDate(f)
        t.body2TextProvider = time(f)
        return t
    }
    
    fileprivate func utilitarianSmall(_ f: Feed) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianSmallFlat()
//        t.imageProvider = TODO
        t.textProvider = relativeDate(f)
        return t
        
    }
    
    fileprivate func utilitarianLarge(_ f: Feed) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianLargeFlat()
//        t.imageProvider = CLKImageProvider(onePieceImage: <#T##UIImage#>, twoPieceImageBackground: <#T##UIImage?#>, twoPieceImageForeground: <#T##UIImage?#>)
        t.textProvider = relativeDate(f)
        return t
    }
    
    fileprivate func circularSmall(_ f: Feed) -> CLKComplicationTemplate {
        let form = MeasurementFormatter()
        form.unitOptions = .providedUnit
        form.unitStyle = .short
        //form.numberFormatter = nf()
        

        let t = CLKComplicationTemplateCircularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "\(form.string(from: f.amount))", shortText: "\(Int(f.amount.value))")
        t.line2TextProvider = relativeDate(f)
        
        return t
    }
    
}
