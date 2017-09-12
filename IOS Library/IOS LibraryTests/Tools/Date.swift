//
//  Date.swift
//  IOS Library
//
//  Created by Алексей on 13.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import XCTest
@testable import IOSLibrary

public class DateExtendsTests: XCTestCase {

    public func testParse() {

        XCTAssertNotNil(Date.parseJson(value: "2017-09-12T12:34:57.98"))
        XCTAssertNotNil(Date.parseJson(value: "2017-09-12T12:34:57.98Z"))
        XCTAssertNotNil(Date.parseJson(value: "2017-09-12T12:34:57"))
        XCTAssertNotNil(Date.parseJson(value: "2017-09-12T12:34:57Z"))
    }
}
