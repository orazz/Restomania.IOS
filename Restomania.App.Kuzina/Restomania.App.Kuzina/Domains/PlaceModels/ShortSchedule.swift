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

    public var sunday: String
    public var monday: String
    public var tuesday: String
    public var wednesday: String
    public var thursday: String
    public var friday: String
    public var saturday: String

    public init() {

        self.sunday = String.empty
        self.monday = String.empty
        self.tuesday = String.empty
        self.wednesday = String.empty
        self.thursday = String.empty
        self.friday = String.empty
        self.saturday = String.empty
    }

    public func dayValue(_ weekDay: Int) -> Day {
        let days = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]

        let number = abs(weekDay) % 7
        return Day(value: days[number], number: number)
    }
    public func takeToday() -> String {

        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        return dayValue(day).toString()
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
    }
    // MARK: Glossy
    public required init(json: JSON) {

        self.sunday = ("Sunday" <~~ json)!
        self.monday = ("Monday" <~~ json)!
        self.tuesday = ("Tuesday" <~~ json)!
        self.wednesday = ("Wednesday" <~~ json)!
        self.thursday = ("Thursday" <~~ json)!
        self.friday = ("Friday" <~~ json)!
        self.saturday = ("Saturday" <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
            "Sunday" ~~> sunday,
            "Monday" ~~> monday,
            "Tuesday" ~~> tuesday,
            "Wednesday" ~~> wednesday,
            "Thursday" ~~> thursday,
            "Friday" ~~> friday,
            "Saturday" ~~> saturday
            ])
    }

    public class Day {

        private let _value: String
        private let _number: Int

        public init(value: String, number: Int) {

            _value = value
            _number = number
        }

        public func toString() -> String {

            if (String.isNullOrEmpty(_value)) {
                return String.empty
            }

            let minutesInDay = 60 * 24

            let components = _value.components(separatedBy: "-")
            let open = Int(components.first!)! - _number * minutesInDay
            let close = Int(components.last!)! - _number * minutesInDay

            return "\(format(open)) - \(format(close))"
        }
        private func format(_ minutes: Int) -> String {
            return "\(minutes / 60):\(minutes % 60)"
        }
    }
}
