//
//  TrackerStore.swift
//  Tracker
//
//  Created by Almira Khafizova on 25.11.23.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store() -> Void
}

final class TrackerStore: NSObject {
    private var context: NSManagedObjectContext
    /* 1:   Контроллер объявлен как переменная с модификатором lazy
            и инициализируется при первом обращении к нему.
            Тип переменной NSFetchedResultsController<TrackerCoreData> указывает,
            что у объектов, с которыми работает контроллер, тип TrackerCoreData. */
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private let uiColorMarshalling = UIColorMarshalling()
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.tracker(from: $0)})
        else { return [] }
        return trackers
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        /* 2:   Cоздаём запрос NSFetchRequest<TrackerCoreData> —
        он работает с объектами типа TrackerCoreData.*/
        let fetch = TrackerCoreData.fetchRequest()
        /* 3:   Обязательно указываем минимум один параметр сортировки. */
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        /* 4:   Для создания контроллера укажем два обязательных параметра:
                - запрос NSFetchRequest — в нём содержится минимум один параметр сортировки;
                - контекст NSManagedObjectContext — он нужен для выполнения запроса. */
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        /* 5:   Назначаем контроллеру делегата, чтобы уведомлять об изменениях. */
        controller.delegate = self
        self.fetchedResultsController = controller
        /* 6:   Делаем выборку данных. */
        try controller.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule?.map {
            $0.rawValue
        }
        try context.save()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let emoji = trackerCoreData.emoji,
              let color = uiColorMarshalling.color(from: trackerCoreData.color ?? ""),
              let name = trackerCoreData.name,
              let schedule = trackerCoreData.schedule
        else {
            fatalError()
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule.map({ TrackerSchedule.DaysOfTheWeek(rawValue: $0)!}))
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

