//
//  InterfaceController.swift
//  BabyTimer WatchKit Extension
//
//  Created by Jin Yu on 1/14/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications
import RealmSwift
import CloudKit

class InterfaceController: WKInterfaceController {
    let cloudKit = false
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var slider: WKInterfaceSlider!
    
    var amount: Float = 2.0
    var delta: TimeInterval = 0
    
//    static var lastAmount = 1.0
//    static var lastDate = Date()
    
    let amountKey = "amount"
//    let dateKey = "date"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        debug(context as Any)
        
        if let feed = context as? Fluid {
            amount = Float(feed.liter)
        } else {
            //To retrieve from the key
            let userDefaults = Foundation.UserDefaults.standard
            amount = userDefaults.float(forKey: amountKey)
        }
        debug(amount)

        // Configure interface objects here.
        setLabelText(amount)
        slider.setValue(amount)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        debug(1)
        UserNotificationCenterDelegate.setupReminder(minutes: 0.5)

        super.didDeactivate()
    }

    @IBAction func quitMenu() {
        let x:Int? = nil
        print(x!)
    }
    
    @IBAction func feedClick() {
        debug("")

//        amount += 1
//        label.setText("\(amount)")
        let time = Date(timeIntervalSinceNow: -delta)
        
        timer.setDate(time)
        timer.start()
        
//        baby.feedList.append(FeedStruct(amount: Measurement(value: Double(amount), unit: UnitVolume.fluidOunces), time: time))
//        baby.feed(<#T##feed: Feed##Feed#>)
        let f = Fluid()
        f.liter = Double(amount)/1000
        f.time = time
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(f)
        }
        
        if cloudKit {
            let record = CKRecord(recordType: "Feed")
            record["amount"] = amount as CKRecordValue
            record["time"] = time as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(record) { /*[unowned self]*/ record, error in
                DispatchQueue.main.async {
                    if let error = error {
                        log.error(error)
                    } else {
                        log.debug("CloudKit")
                    }
                    
                    //                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
                }
            }
            
        }
        
//        let audioURL = RecordWhistleViewController.getWhistleURL()
//        let whistleAsset = CKAsset(fileURL: audioURL)
//        record["audio"] = whistleAsset
        
        // get the shared instance
        let server = CLKComplicationServer.sharedInstance()
        // extend the timeline for all complications
        for complication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
        
        self.pop()
    }
    
    @IBAction func sliderChange(_ value: Float) {
        debug(value)
        //To save the string
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(value, forKey: amountKey)

        setLabelText(value)
        amount = value
    }
    
    @IBOutlet var feedTime: WKInterfaceTimer!
    @IBAction func timeChange(_ value: Float) {
        debug(value)
        
        delta = TimeInterval(value)
        feedTime.setDate(Date(timeIntervalSinceNow: -delta))
//        feedTime.start()
    }
    
    func setLabelText(_ value: Float) {
        let ml = Measurement(value: Double(value), unit: UnitVolume.milliliters)
        let oz = ml.converted(to: UnitVolume.fluidOunces)
        label.setText("\(ml), \(Double(Int(oz.value*10))/10.0) oz")
    }
}
