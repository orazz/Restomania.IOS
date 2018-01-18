//
//  Date.swift
//  IOS Library
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public enum DayOfWeek: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}
extension Date {

    public static var ISOFormatter: DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        result.timeZone = TimeZone.utc

        return result
    }

    public static func parseJson(value: String) -> Date {

        var date = value

        let components = date.components(separatedBy: ".")
        if (components.count != 1) {

            date = ""
            for i in 0...(components.count-2) {

                date += components[i]
            }
        }

        if (!date.hasSuffix("Z")) {

            date += "Z"
        }

       return Date.ISOFormatter.date(from: date)!
    }
    public func prepareForJson() -> String {

        return Date.ISOFormatter.string(from: self)
    }

    public func hours() -> Int {
        return component(.hour)
    }
    public func minutes() ->  Int {
        return component(.minute)
    }
    public func dayOfWeek() -> DayOfWeek {
        return DayOfWeek(rawValue: component(.weekday) - 1)!
    }
    private func component(_ part: Calendar.Component) -> Int {

        let calendar = NSCalendar.current
        let component = calendar.component(part, from: self)

        return component
    }

    public func utcHours() -> Int {
        return utcComponent(.hour)
    }
    public func utcMinutes() ->  Int {
        return utcComponent(.minute)
    }
    public func utcDayOfWeek() -> DayOfWeek {
        return DayOfWeek(rawValue: utcComponent(.weekday) - 1)!
    }
    private func utcComponent(_ part: Calendar.Component) -> Int {

        var calendar = Calendar.utcCurrent
        let component = calendar.component(part, from: self)

        return component
    }

    public var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    public var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    public var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    public var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    public var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
