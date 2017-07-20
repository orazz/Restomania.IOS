//
//  PropertiesStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import IOSLibrary
@testable import RestomaniaAppKuzina

public class PropertiesStorageTests: XCTestCase {

    override public func setUp() {
        super.setUp()

        PropertiesStorage.remove(.Test)
    }

    public func testHasValueAndRemove() {
        let value = "test string"

        XCTAssertFalse(PropertiesStorage.hasValue(.Test))

        PropertiesStorage.set(.Test, value: value)
        XCTAssertTrue(PropertiesStorage.hasValue(.Test))

        PropertiesStorage.remove(.Test)
        XCTAssertFalse(PropertiesStorage.hasValue(.Test))
    }
    public func testString() {
        let value = "test string"

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getString(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
    public func testInt() {
        let value = Int(43)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getInt(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
    public func testLong() {
        let value = Long(43)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getLong(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
    public func testFloat() {
        let value = Float(13.45)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getFloat(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
    public func testDouble() {
        let value = Double(13.45)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getDouble(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
    public func testDate() {
        let value = Date(timeIntervalSinceNow: 234)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getDate(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value.timeIntervalSince1970, newValue.value.timeIntervalSince1970)
    }
    public func testBool() {
        let value = true

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.getBool(.Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value, newValue.value)
    }
}
