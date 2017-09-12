//
//  Date.swift
//  IOS Library
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

extension Date {

    public static var ISOFormatter: DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        result.timeZone = TimeZone(identifier: "UTC")

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
}
