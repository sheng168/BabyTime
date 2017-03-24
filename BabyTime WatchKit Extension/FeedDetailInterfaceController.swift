//
//  FeedDetailInterfaceController.swift
//  BabyTime
//
//  Created by Jin Yu on 2/26/17.
//  Copyright © 2017 Kewe. All rights reserved.
//

import WatchKit
import Foundation
//import RealmSwift

class FeedDetailInterfaceController: WKInterfaceController {
    var feed: Fluid?
    
    @IBOutlet var amountLabel: WKInterfaceLabel!
    @IBOutlet var date: WKInterfaceDate!
    @IBOutlet var timer: WKInterfaceTimer!
    
    @IBAction func deleteClick() {
        let action = WKAlertAction(title: "Delete", style: .destructive) { 
            try! realm.write {
                realm.delete(self.feed!)
            }
            self.pop()
        }
        presentAlert(withTitle: "Delete?", message: nil, preferredStyle: .actionSheet, actions: [action])
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        log.debug(context as Any)
        
        if let feed = context as? Fluid {
            self.feed = feed
            amountLabel.setText("\(feed.amount)")
//            date.setCalendar()
            timer.setDate(feed.time)
            timer.start()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
