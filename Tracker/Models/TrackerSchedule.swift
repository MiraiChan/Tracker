//
//  TrackerSchedule.swift
//  Tracker
//
//  Created by Almira Khafizova on 03.11.23.
//

struct TrackerSchedule {
    enum DaysOfTheWeek: CaseIterable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
        
        func getNameOfWeekDays(from: DaysOfTheWeek) -> String {
            switch self {
            case .monday:
                return "Понедельник"
            case .tuesday:
                return "Вторник"
            case .wednesday:
                return "Среда"
            case .thursday:
                return "Четверг"
            case .friday:
                return "Пятница"
            case .saturday:
                return "Суббота"
            case .sunday:
                return "Воскресенье"
            }
        }
    }
}
