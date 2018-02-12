//
//  ShortSchedule.swift
//  Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class ShortSchedule: Glossy, ICopying {

    private var sunday: String
    private var monday: String
    private var tuesday: String
    private var wednesday: String
    private var thursday: String
    private var friday: String
    private var saturday: String

    private var days = [Day]()

    public init() {
        self.sunday = String.empty
        self.monday = String.empty
        self.tuesday = String.empty
        self.wednesday = String.empty
        self.thursday = String.empty
        self.friday = String.empty
        self.saturday = String.empty

        buildDays()
    }

    // MARK: ICopying
    public required init(source: ShortSchedule) {

        self.sunday = source.sunday
        self.monday = source.monday
        self.tuesday = source.tuesday
        self.wednesday = source.wednesday
        self.thursday = source.thursday
        self.friday = source.friday
        self.saturday = source.saturday

        buildDays()
    }
    private func buildDays() {
        days = [
            Day(value: sunday, day: .sunday),
            Day(value: monday, day: .monday),
            Day(value: tuesday, day: .tuesday),
            Day(value: wednesday, day: .wednesday),
            Day(value: thursday, day: .thursday),
            Day(value: friday, day: .friday),
            Day(value: saturday, day: .saturday)
        ]
    }

    // MARK: Glossy
    private struct Keys {
        public static let sunday = "Sunday"
        public static let monday = "Monday"
        public static let tuesday = "Tuesday"
        public static let wednesday = "Wednesday"
        public static let thursday = "Thursday"
        public static let friday = "Friday"
        public static let saturday = "Saturday"
    }
    public required init(json: JSON) {

        self.sunday = (Keys.sunday <~~ json)!
        self.monday = (Keys.monday <~~ json)!
        self.tuesday = (Keys.tuesday <~~ json)!
        self.wednesday = (Keys.wednesday <~~ json)!
        self.thursday = (Keys.thursday <~~ json)!
        self.friday = (Keys.friday <~~ json)!
        self.saturday = (Keys.saturday <~~ json)!

        buildDays()
    }
    public func toJSON() -> JSON? {

        return jsonify([
            Keys.sunday ~~> sunday,
            Keys.monday ~~> monday,
            Keys.tuesday ~~> tuesday,
            Keys.wednesday ~~> wednesday,
            Keys.thursday ~~> thursday,
            Keys.friday ~~> friday,
            Keys.saturday ~~> saturday
            ])
    }
}

//Display schedule
extension ShortSchedule {

    public func canOrder(on date: Date) -> Bool {

        let dayOfWeek = date.utcDayOfWeek().rawValue
        let days = [takeDay(dayOfWeek - 1),
                    takeDay(dayOfWeek),
                    takeDay(dayOfWeek + 1)]

        for day in days {
            if (day.canOrder(at: date)) {
                return true
            }
        }

        return false
    }
    public func takeDay(_ weekDay: DayOfWeek) -> Day {
        return takeDay(weekDay.rawValue)
    }
    public func takeDay(_ weekDay: Int) -> Day {

        let number = ((weekDay % 7) + 7) % 7
        return days[number]
    }
    public func takeToday() -> String {

        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        return takeDay(day).description
    }
}
extension ShortSchedule {
    public class Day: CustomStringConvertible {

        private static let minutesInWeek = 7 * minutesInDay
        private static let minutesInDay = 24 * minutesInHour
        private static let minutesInHour = 60

        private let value: String
        private let day: DayOfWeek
        private var open: Int
        private var close: Int

        fileprivate init(value: String, day: DayOfWeek) {

            self.value = value
            self.day = day
            self.open = -1
            self.close = -1

            if (String.isNullOrEmpty(value)) {
                return
            }
            let components = value.components(separatedBy: "-")
            if (components.count != 2) {
                return
            }

            open = Int(components.first!)!
            close = Int(components.last!)!
        }

        public var isHoliday: Bool {
            return -1 == open || -1 == close
        }
        public var description: String {

            if (isHoliday) {
                return String.empty
            }

            let open = self.open - day.rawValue * Day.minutesInDay
            let close = self.close - day.rawValue * Day.minutesInDay
            return "\(format(open)) - \(format(close))"
        }
        private func format(_ minutes: Int) -> String {
            return "\(String(format: "%02d", minutes / 60)):\(String(format: "%02d", minutes % 60))"
        }

        fileprivate func canOrder(at date: Date) -> Bool {

            if (isHoliday) {
                return false
            }

            let orderMinutes = date.utcDayOfWeek().rawValue * Day.minutesInDay +
                               date.utcHours() * Day.minutesInHour +
                               date.utcMinutes()
            return canOrder(at: orderMinutes) || canOrder(at: orderMinutes + Day.minutesInWeek)
        }
        private func canOrder(at minutes: Int) -> Bool {
            return open < minutes && minutes < close
        }
    }
}
