//
//  TrackersStorage.swift
//  Tracker
//
//  Created by Almira Khafizova on 08.11.23.
//

import UIKit

protocol TrackersStorageProtocol {
    
    func addTracker(category: String, name: String, schedule: [TrackerSchedule.DaysOfTheWeek]?, emoji: String, color: Int) -> UInt
    
    func getTracker(id: UInt) -> Tracker?
    
    func getCategories() -> [TrackerCategory]
}

final class TrackersStorage: TrackersStorageProtocol {
    private var counter: UInt = 0
    private var categories: [TrackerCategory] = []
    private var trackers: [Tracker] = []
    
    init() {
        let homeCategory = TrackerCategory(title: "Домашний уют")
        categories.append(homeCategory)
        addTracker(category: homeCategory.title, name: "Поливать растения", schedule: [TrackerSchedule.DaysOfTheWeek.monday, TrackerSchedule.DaysOfTheWeek.saturday], emoji: "❤️", color: UIColor.green.convertToRgba()!)
        
        let joyCategory = TrackerCategory(title: "Радостные мелочи")
        categories.append(joyCategory)
        addTracker(category: joyCategory.title, name: "Кошка заслонила камеру на созвоне", schedule: [TrackerSchedule.DaysOfTheWeek.monday], emoji: "😻", color: UIColor.orange.convertToRgba()!)
        addTracker(category: joyCategory.title, name: "Бабушка прислала открытку в вотсапе", schedule: [TrackerSchedule.DaysOfTheWeek.monday], emoji: "🌺", color: UIColor.red.convertToRgba()!)
        addTracker(category: joyCategory.title, name: "Свидания в апреле", schedule: [TrackerSchedule.DaysOfTheWeek.monday], emoji: "❤️", color: UIColor.blue.convertToRgba()!)
    }
    
    @discardableResult // to mute yellow warnings
    func addTracker(category: String, name: String, schedule: [TrackerSchedule.DaysOfTheWeek]?, emoji: String, color: Int) -> UInt {
        let id = counter
        counter += 1
        
        let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule ?? [] )
        trackers.append(tracker)
        
        if let index = categories.firstIndex(where: { $0.title == category }) {
            self.categories[index].trackers.append(tracker)
        } else {
            let newCategory = TrackerCategory(title: category)
            categories.append(newCategory)
        }
        return id
    }
    
    func getTracker(id: UInt) -> Tracker? {
        return trackers.first(where: { $0.id == id })
    }
    
    func getCategories() -> [TrackerCategory] {
        return categories
    }
}
