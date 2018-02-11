//
//  DateFilter.swift
//  MdsKit
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class DateTimeFilter: IFilter {
    private let _type: ValueType

    init(type: ValueType) {
        _type = type
    }

    public func search(phrase: String, field: Any) -> Bool {

        let value = field as? Date
        if (nil == value) {
            return false
        }

        let splitted = matches(for: "\\d+", in: phrase)

        switch(splitted.count) {
            case 0:
                return false

            case 1:
                return checkOneDigit(splitted.first!, forDate: value!)

            default:
                return checkMoreOneDigit(splitted, forDate: value!)
        }
    }
    private func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))

            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    //One digit
    private func checkOneDigit(_ digit: String, forDate date: Date) -> Bool {

        let digit = Int(digit)!

        switch _type {
            case .Time:
                return Check(value: digit, date:date, values:.hour, .minute)

            case .Date:
                return Check(value: digit, date:date, values:.day, .month)

            case .DateTime:
                return Check(value: digit, date:date, values:.day, .month, .hour, .minute)

            default:
                return false
        }
    }
    private func Check(value: Int, date: Date, values: Calendar.Component...) -> Bool {

        let calendar = Calendar.utcCurrent

        for component in values {

            if (value == calendar.component(component, from: date)) {
                return true
            }
        }

        return false
    }

    //Two digit
    private func checkMoreOneDigit(_ digits: [String], forDate value: Date) -> Bool {

        let digits = digits.map({ digit in Int(digit)!})
        let calendar = Calendar.utcCurrent

        let left = (digits[0], digits[1])
        let time = (calendar.component(.hour, from: value), calendar.component(.minute, from: value))
        let date = (calendar.component(.month, from: value), calendar.component(.day, from: value))

        switch _type {
            case .Time:
                return Check(left, time)

            case .Date:
                return Check(left, date)

            case .DateTime:
                return Check(left, time) || Check(left, date)

        default:
            return false
        }
    }
    private func Check(_ left: (Int, Int), _ right: (Int, Int)) -> Bool {
        return (left.0 == right.0 && left.1 == right.1) ||
               (left.0 == right.1 && left.1 == right.0)
    }
}
