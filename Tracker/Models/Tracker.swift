//
//  Tracker.swift
//  Tracker
//
//  Created by Almira Khafizova on 03.11.23.
//

import UIKit

struct Tracker {
    let id: UInt
    let name: String
    let color: Int
    let emoji: String
    let schedule: [TrackerSchedule.DaysOfTheWeek]
}
