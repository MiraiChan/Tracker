//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Almira Khafizova on 25.11.23.
//

import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func storeRecord()
}

final class TrackerRecordStore: NSObject {
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
}


