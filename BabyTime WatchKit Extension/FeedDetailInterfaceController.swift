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
    var feed: RealmFeed?
    
    @IBOutlet var amountLabel: WKInterfaceLabel!
    
    @IBAction func deleteClick() {
        try! realm.write {
            realm.delete(feed!)
        }
        pop()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        log.debug(context)
        
        if let feed = context as? RealmFeed {
            self.feed = feed
            amountLabel.setText("\(feed.amount)")
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
