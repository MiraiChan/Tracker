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
        
        //This method to convert a numeric day of the week value into a more readable and understandable enumeration value.
        static func getWeekDay(weekDayInt: Int) -> DaysOfTheWeek {
            var index = weekDayInt - 1
            if index < 0 {
                index += DaysOfTheWeek.allCases.count
            }
            return DaysOfTheWeek.allCases[index]
        }
    }
}
