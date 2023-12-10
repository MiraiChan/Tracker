//
//  TrackerStore.swift
//  Tracker
//
//  Created by Almira Khafizova on 26.11.23.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store() -> Void
}

final class TrackerStore: NSObject {
    enum TrackerError: Error {
        case invalidTrackerCoreData
        case invalidScheduleValue(Int)
        case fetchError(Error)
    }
    
    private var context: NSManagedObjectContext
    /* 1:   Контроллер объявлен как переменная с модификатором lazy
     и инициализируется при первом обращении к нему.
     Тип переменной NSFetchedResultsController<TrackerCoreData> указывает,
     что у объектов, с которыми работает контроллер, тип TrackerCoreData. */
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.context {
            do {
                try self.init(context: context)
            } catch {
                assertionFailure("Failed to initialize TrackerRecordStore. Error: \(error)")
                self.init() //TODO: Call the designated initializer with default behavior or handle it
            }
        } else {
            assertionFailure("Unable to obtain CoreData context.")
            self.init()  //TODO: Call the designated initializer with default behavior or handle it 
        }
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            throw TrackerError.fetchError(error)
        }
    }
    
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        
        trackerCoreData.schedule = tracker.schedule?.map {
            $0.rawValue
        }
        try context.save()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let emoji = trackerCoreData.emoji,
              let color = UIColorMarshalling.color(from: trackerCoreData.color ?? ""),
              let name = trackerCoreData.name,
              let scheduleArray = trackerCoreData.schedule
        else {
            throw TrackerError.invalidTrackerCoreData
        }
        
        let schedule = try scheduleArray.map {
            guard let day = TrackerSchedule.DaysOfTheWeek(rawValue: $0) else {
                throw TrackerError.invalidScheduleValue($0)
            }
            return day
        }
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
    }
}
//Делегат передает данные об изменениях.
extension TrackerStore: NSFetchedResultsControllerDelegate {
    /* Метод controllerDidChangeContent срабатывает после
     добавления или удаления объектов. В нём мы передаём индексы
     изменённых объектов в класс TrackersViewController и очищаем до следующего изменения
     переменные, которые содержат индексы. */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store()
    }
}
