//
//  HistoryInterfaceController.swift
//  BabyTime
//
//  Created by sheng on 2/11/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class HistoryInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!

    let realm = try! Realm()
    //.filter("age < 2")
    lazy var f = realm.objects(Fluid.self).sorted(byKeyPath: "time", ascending: true)
    var token: NotificationToken!
    
//    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
//        log.debug(rowIndex)
//        let f = (table.rowController(at: rowIndex) as? RowController)?.feed
////        presentController(withName: "detail", context: f)
//        pushController(withName: "detail", context: f)
//    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        log.debug(rowIndex)
        let f = (table.rowController(at: rowIndex) as? RowController)?.feed
        return f
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        log.debug(0) // not showing because log is not initialized yet
        print("HistoryInterfaceController.awake")
    }

    override func willActivate() {
        log.debug(1)
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        token = f.addNotificationBlock { (colChange) in
            print(colChange)
            self.update()
        }
        // Configure interface objects here.


    }
    
    func update() {
        table.setNumberOfRows(f.count, withRowType: "Row")
        
        for i in 0 ..< f.count {
            if let controller = table.rowController(at: i) as? RowController {
                controller.feed = f[i]
            }
        }
    }

    override func didDeactivate() {
        log.debug(-1)
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

class RowController: NSObject {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var detailLabel: WKInterfaceLabel!
    @IBOutlet var timer: WKInterfaceTimer!
    
    var feed: Fluid? {
        didSet {
            log.verbose(feed as Any)
            let form = MeasurementFormatter()
            form.unitOptions = .providedUnit
            form.unitStyle = .short

            if let feed = feed {
                titleLabel.setText("\(form.string(from: feed.amount))")
                detailLabel.setText("\(feed.time)")
                timer.setDate(feed.time)
                timer.start()
            }
        }
    }
}
