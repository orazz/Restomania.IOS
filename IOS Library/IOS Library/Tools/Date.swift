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
        return Date.ISOFormatter.date(from: value)!
    }
    public func prepareForJson() -> String {
        return Date.ISOFormatter.string(from: self)
    }
}
