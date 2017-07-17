//
//  Date.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class DateTests: XCTestCase {
    public func testConvertDateToUniversalFormat() {
        var components = DateComponents()
        components.year = 1980
        components.month = 7
        components.day = 11
        components.timeZone = TimeZone(abbreviation: "KRAT")
        components.hour = 8
        components.minute = 34
        components.second = 12

        let calendar = Calendar.current
        let date = calendar.date(from: components)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")!

//        calendar.dateComponents([.hour, .], from: date)

        XCTAssertEqual("1980-07-11T08:34:12.0Z", formatter.string(from: date!))
    }
}
