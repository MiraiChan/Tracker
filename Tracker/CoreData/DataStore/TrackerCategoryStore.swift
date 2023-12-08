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
        }
        try context.save()
    }
    
    func addTrackerToCategory(to title: String?, tracker: Tracker) throws {
        guard let fromDb = try self.fetchTrackerCategory(with: title) else {
            assertionFailure("Failed to fetch the tracker category with title: \(title ?? "")")
            return
        }
        fromDb.trackers = trackerCategories.first {
            $0.title == title
        }?.trackers.map { $0.id }
        print(type(of: fromDb.trackers))
        fromDb.trackers?.append(tracker.id)
        try context.save()
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title,
              let rawTrackers = trackerCategoryCoreData.trackers
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
        
        return TrackerCategory(title: title, trackers: filteredTrackers)
    }
    
    func fetchTrackerCategory(with title: String?) throws -> TrackerCategoryCoreData? {
        guard let title = title else {
            throw TrackerError.invalidTitle
        }
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
    
    enum TrackerError: Error {
        case invalidTrackersType
        case invalidTitle
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategory()
    }
}

