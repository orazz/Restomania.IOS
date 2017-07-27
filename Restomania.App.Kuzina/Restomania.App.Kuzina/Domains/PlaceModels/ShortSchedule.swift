//
//  ShortSchedule.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class ShortSchedule: Glossy, ICopying {

    public var Sunday: String
    public var Monday: String
    public var Tuesday: String
    public var Wednesday: String
    public var Thursday: String
    public var Friday: String
    public var Saturday: String

    public init() {

        self.Sunday = String.Empty
        self.Monday = String.Empty
        self.Tuesday = String.Empty
        self.Wednesday = String.Empty
        self.Thursday = String.Empty
        self.Friday = String.Empty
        self.Saturday = String.Empty
    }
    public required init(json: JSON) {

        self.Sunday = ("Sunday" <~~ json)!
        self.Monday = ("Monday" <~~ json)!
        self.Tuesday = ("Tuesday" <~~ json)!
        self.Wednesday = ("Wednesday" <~~ json)!
        self.Thursday = ("Thursday" <~~ json)!
        self.Friday = ("Friday" <~~ json)!
        self.Saturday = ("Saturday" <~~ json)!
    }
    public required init(source: ShortSchedule) {

        self.Sunday = source.Sunday
        self.Monday = source.Monday
        self.Tuesday = source.Tuesday
        self.Wednesday = source.Wednesday
        self.Thursday = source.Thursday
        self.Friday = source.Friday
        self.Saturday = source.Saturday
    }

    public func toJSON() -> JSON? {

        return jsonify([
            "Sunday" ~~> Sunday,
            "Monday" ~~> Monday,
            "Tuesday" ~~> Tuesday,
            "Wednesday" ~~> Wednesday,
            "Thursday" ~~> Thursday,
            "Friday" ~~> Friday,
            "Saturday" ~~> Saturday
            ])
    }

    public func dayValue(_ weekDay: Int) -> String {
        let days = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]

        return days[abs(weekDay) % 7]
    }
    public func takeToday() -> String {

        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)

        let value = dayValue(day)

        if (String.IsNullOrEmpty(value)) {
            return value
        }

        return value.replacingOccurrences(of: "-", with: " - ")
    }
}
