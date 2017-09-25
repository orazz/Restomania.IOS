//
//  String.swift
//  IOS Library
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class StringTests {

    public func testString() {
        XCTAssertEqual("", String.empty)

        XCTAssertTrue(String.isNullOrEmpty(""))
        XCTAssertTrue(String.isNullOrEmpty(nil))

        XCTAssertFalse(String.isNullOrEmpty("Test"))
    }
}
