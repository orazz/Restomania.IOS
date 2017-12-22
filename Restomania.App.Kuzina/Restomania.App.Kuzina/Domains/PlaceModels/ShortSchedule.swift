//
//  ShortSchedule.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

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

    public class Day {
        private let value: String
        private let day: DayOfWeek

        fileprivate init(value: String, day: DayOfWeek) {

            self.value = value
            self.day = day
        }
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

    public func dayValue(_ weekDay: Int) -> Day {

        let number = abs(weekDay) % 7
        return days[number]
    }
    public func takeToday() -> String {

        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        return dayValue(day).toString()
    }
}
extension ShortSchedule.Day {

    public func toString() -> String {

        if (String.isNullOrEmpty(value)) {
            return String.empty
        }

        let components = value.components(separatedBy: "-")
        if (components.count < 2) {
            return String.empty
        }

        let minutesInDay = 60 * 24
        let open = Int(components.first!)! - day.rawValue * minutesInDay
        let close = Int(components.last!)! - day.rawValue * minutesInDay

        return "\(format(open)) - \(format(close))"
    }
    private func format(_ minutes: Int) -> String {
        return "\(minutes / 60):\(minutes % 60)"
    }
}
