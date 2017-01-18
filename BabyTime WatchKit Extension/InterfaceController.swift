//
//  InterfaceController.swift
//  BabyTimer WatchKit Extension
//
//  Created by Jin Yu on 1/14/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var slider: WKInterfaceSlider!
    
    var amount: Float = 2.0
    
//    static var lastAmount = 1.0
//    static var lastDate = Date()
    
    let amountKey = "amount"
    let dateKey = "date"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        debug(context)
        
        //To retrieve from the key
        let userDefaults = Foundation.UserDefaults.standard
        let amount = userDefaults.float(forKey: amountKey)
        debug(amount)

        // Configure interface objects here.
        setLabelText(amount)
        slider.setValue(amount)
}
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        debug(1)
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        debug(1)
        super.didDeactivate()
    }

    @IBAction func feedClick() {
        debug("")

//        amount += 1
//        label.setText("\(amount)")
        timer.setDate(Date())
        timer.start()
        
        Feed.list.append(Feed(amount: amount))
        
        // get the shared instance
        let server = CLKComplicationServer.sharedInstance()
        // extend the timeline for all complications
        for complication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
    }
    
    @IBAction func sliderChange(_ value: Float) {
        debug(value)
        //To save the string
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(value, forKey: amountKey)

        setLabelText(value)
        amount = value
    }
    
    func setLabelText(_ value: Float) {
        label.setText("\(value) oz")
    }
}
