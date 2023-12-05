//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Almira Khafizova on 25.11.23.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategory() -> Void
}

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    
    private var context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let trackerStore = TrackerStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0)})
        else { return [] }
        return categories
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerCategoryCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = category.title
        trackerCategoryCoreData.trackers = category.trackers.map {
            $0.id
        } as NSObject
        try context.save()
    }
    
    func addTrackerToCategory(to header: String?, tracker: Tracker) throws {
        guard let header = header, var fromDB = try self.fetchTrackerCategory(with: header) else {
            throw TrackerError.invalidHeader
        }
        if fromDB.trackers == nil {
            fromDB.trackers = NSMutableArray()
            
        }
        if let mutableTrackers = fromDB.trackers as? NSMutableArray {
            mutableTrackers.add(tracker.id)
            try context.save()
        } else {
            assertionFailure()
        }
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = trackerCategoryCoreData.title,
              let rawTrackers = trackerCategoryCoreData.trackers as? [Any]
        else {
            throw TrackerError.invalidTrackersType
        }
        
        let filteredTrackers = trackerStore.trackers.filter { tracker in
            let trackerID = tracker.id
            return rawTrackers.contains(where: { (rawTracker) -> Bool in
                if let rawTrackerID = rawTracker as? UUID {
                    return rawTrackerID == trackerID
                }
                return false
            })
        }
        
        return TrackerCategory(title: header, trackers: filteredTrackers)
    }
    
    func fetchTrackerCategory(with header: String?) throws -> TrackerCategoryCoreData? {
        guard let header = header else {
            throw TrackerError.invalidHeader
        }
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "header == %@", header as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
    
    enum TrackerError: Error {
        case invalidTrackersType
        case invalidHeader
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategory()
    }
}

