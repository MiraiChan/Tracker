//
//  TrackersStorage.swift
//  Tracker
//
//  Created by Almira Khafizova on 08.11.23.
//

import UIKit

final class TrackersStorage {
    static let shared = TrackersStorage()
    var categories: [TrackerCategory] = [
//        TrackerCategory(
//            title: "Домашний уют",
//            trackers: [
//                Tracker (
//                    id: UUID, name: "Поливать растения",
//                    color: .ypColorSelection5,
//                    emoji:"❤️",
//                    schedule: [TrackerSchedule.DaysOfTheWeek.monday]
//                ),
//                
//                Tracker (
//                    id: UUID, name: "Удобрять растения",
//                    color: .ypColorSelection1,
//                    emoji:"🌺",
//                    schedule: [TrackerSchedule.DaysOfTheWeek.tuesday]
//                )
//            ]
//        ),
//        
//        TrackerCategory(
//            title: "Радостные мелочи",
//            trackers: [
//                Tracker (
//                    id: UUID, name: "Кошка заслонила камеру на созвоне",
//                    color: .ypColorSelection12,
//                    emoji:"😻",
//                    schedule: [TrackerSchedule.DaysOfTheWeek.saturday]
//                ),
//                
//                Tracker (
//                    id: UUID, name: "Свидания в апреле",
//                    color: .ypColorSelection11,
//                    emoji:"❤️",
//                    schedule: [TrackerSchedule.DaysOfTheWeek.tuesday]
//                )
//            ]
//        )
    ]
    
    private init() {}
}
