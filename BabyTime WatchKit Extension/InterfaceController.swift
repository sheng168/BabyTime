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
    var amount = 2.0
    
    static var lastAmount = 1.0
    static var lastDate = Date()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setLabelText(2)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func feedClick() {
        print("feed")
//        amount += 1
//        label.setText("\(amount)")
        timer.setDate(Date())
        timer.start()
        
        InterfaceController.lastAmount = amount
        InterfaceController.lastDate = Date()
        
        // get the shared instance
        let server = CLKComplicationServer.sharedInstance()
        // extend the timeline for all complications
        for complication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
    }
    
    @IBAction func sliderChange(_ value: Float) {
        setLabelText(value)
        amount = Double(value)
    }
    
    func setLabelText(_ value: Float) {
        label.setText("\(value) oz")
    }
}
