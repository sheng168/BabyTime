//
//  ComplicationController.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import ClockKit
import os.log

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
//        handler(CLKComplicationTimeTravelDirections())
        debug("getSupportedTimeTravelDirectionsForComplication")
                handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        debug("getTimelineStartDateForComplication")
        let start = Feed.list.first!.time //Date().addingTimeInterval(-100*60)
            
        handler(start)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        debug("getTimelineEndDateForComplication")
        let end = Feed.list.last!.time.addingTimeInterval(60*60*3) //Date().addingTimeInterval(100*60)
        handler(end)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        debug("getPrivacyBehaviorForComplication")
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (@escaping (CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        debug("getCurrentTimelineEntryForComplication")
        
        
        let templ: CLKComplicationTemplate?
        
        switch complication.family {
            //        case .ModularLarge:
            //            let t = modularLarge(10.0)
            //            templ = t
            //        case .ModularSmall:
        //            templ = modularSmall(10.0)
        default:
            templ = getTemplateForComplication(complication, bill: 10)
            break
        }
        
        if templ == nil {
            handler(nil)
        } else {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templ!)
            
            handler(entry)
        }
        
    }
    
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        debug("\(date) \(limit)")
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            var array = [CLKComplicationTimelineEntry]()
            
            for i in 1 ... min(limit,5) {
                let t = self.getTemplateForComplication(complication, bill: Double(i))
                
                let entry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: -600.0*Double(i)), complicationTemplate: t)
                array.append(entry)
            }
            
            DispatchQueue.main.async {
                handler(array)
            }
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        debug("\(date) \(limit)")
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            var array = [CLKComplicationTimelineEntry]()
            
            for i in 1 ... min(limit,5) {
                let t = self.getTemplateForComplication(complication, bill: Double(i))
                
                let entry = CLKComplicationTimelineEntry(date: Date(timeIntervalSinceNow: 60.0*Double(i)), complicationTemplate: t)
                array.append(entry)
            }
            
            handler(array)
        }
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        debug("")
        //        handler(nil)
        handler(Date(timeIntervalSinceNow: 60*60))
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        debug("")
        
        let template: CLKComplicationTemplate? = getTemplateForComplication(complication, bill: 10)
        handler(template)
    }
    
    // MARK: - Generate Templates
    
    func getTemplateForComplication(_ complication: CLKComplication, bill: Double) -> CLKComplicationTemplate {
        // This method will be called once per supported complication, and the results will be cached
        debug("getTemplateForComplication \(bill)")
        
        let template: CLKComplicationTemplate
        
        switch complication.family {
        case .modularSmall:
            template = modularSmall(bill)
        case .modularLarge:
            template = modularLarge(bill)
        case .utilitarianSmall:
            template = utilitarianSmall(bill)
        case .utilitarianLarge:
            template = utilitarianLarge(bill)
        case .circularSmall:
            template = circularSmall(bill)
        case .utilitarianSmallFlat:
            template = utilitarianSmall(bill)
        case.extraLarge:
            let t = CLKComplicationTemplateExtraLargeSimpleText()
            t.textProvider = CLKSimpleTextProvider(text: "Tip", shortText: "Tip")
            template = t
        }
        
        return (template)
    }
    
    fileprivate func modularSmall(_ bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "\(Feed.list.last!.amount)oz")
        t.line2TextProvider = CLKRelativeDateTextProvider(date: (Feed.list.last?.time)!, style: .timer, units: .minute)
        return t
        
    }
    
    fileprivate func modularLarge(_ bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateModularLargeStandardBody()
        t.headerTextProvider = CLKSimpleTextProvider(text: "\(Feed.list.last!.amount)oz \(Feed.list.last!.amount*30)mL")
        t.body1TextProvider = CLKRelativeDateTextProvider(date: (Feed.list.last?.time)!, style: .natural, units: .second)
        t.body2TextProvider = CLKRelativeDateTextProvider(date: (Feed.list.last?.time)!, style: .timer, units: .second)
        return t
    }
    
    fileprivate func utilitarianSmall(_ bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianSmallFlat()
        t.textProvider = CLKSimpleTextProvider(text: "Tip", shortText: "Tip")
        //        t.imageProvider = CLKSimpleTextProvider(text: "$11.50", shortText: "11.50")
        return t
        
    }
    
    fileprivate func utilitarianLarge(_ bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateUtilitarianLargeFlat()
        t.textProvider = CLKSimpleTextProvider(text: "TipCalc $\(bill)")
        
        //        t.body1TextProvider = CLKSimpleTextProvider(text: "+ 15% = $\(bill*1.15)")
        //        t.body2TextProvider = CLKSimpleTextProvider(text: "\(NSDate())")
        return t
    }
    
    fileprivate func circularSmall(_ bill: Double) -> CLKComplicationTemplate {
        let t = CLKComplicationTemplateCircularSmallStackText()
        t.line1TextProvider = CLKSimpleTextProvider(text: "$10", shortText: "10")
        t.line2TextProvider = CLKSimpleTextProvider(text: "11.50", shortText: "11.5")
        
        return t
    }
    
}
