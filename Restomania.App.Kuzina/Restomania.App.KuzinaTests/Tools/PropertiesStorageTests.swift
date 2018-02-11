//
//  PropertiesStorage.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import MdsKit
import Gloss
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
    public func testJSON() {
        let value = Model(name: "max", age:4)

        PropertiesStorage.set(.Test, value: value)
        let newValue = PropertiesStorage.get(Model.self, key: .Test)

        XCTAssertTrue(newValue.hasValue)
        XCTAssertEqual(value.Name, newValue.value.Name)
        XCTAssertEqual(value.Age, newValue.value.Age)
    }

    class Model: Glossy {
        public var Name: String
        public var Age: Int

        public init(name: String, age: Int) {
            self.Name = name
            self.Age = age
        }
        public required init(json: JSON) {
            self.Name = ("Name" <~~ json)!
            self.Age = ("Age" <~~ json)!
        }

        public func toJSON() -> JSON? {
            return jsonify([
                "Name" ~~> Name,
                "Age" ~~> Age
                ])
        }
    }
}
