//
//  Array.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import XCTest
@testable import IOSLibrary

public class ArrayTests: XCTestCase {

    public func testFind() {

        let range = [1, 2, 3, 4]

        XCTAssertNil(range.find({ $0 == 5}))

        XCTAssertNotNil(range.find({ $0 == 1}))
        XCTAssertNotNil(range.find({ $0 == 2}))
        XCTAssertNotNil(range.find({ $0 == 3}))
        XCTAssertNotNil(range.find({ $0 == 4}))
        XCTAssertNotNil(range.find({ $0 % 3 == 0}))
    }
    public func testWhere() {

        let range = [1, 2, 3, 4, 5, 6]

        XCTAssertEqual(1, range.where({ $0 == 1}).first!)
        XCTAssertEqual(2, range.where({ $0 == 2}).first!)
        XCTAssertEqual(3, range.where({ $0 == 3}).first!)
        XCTAssertEqual(4, range.where({ $0 == 4}).first!)
        XCTAssertEqual(5, range.where({ $0 == 5}).first!)
        XCTAssertEqual(6, range.where({ $0 == 6}).first!)

        let filtered = range.where({ $0 % 2 == 0 })
        XCTAssertEqual(3, filtered.count)
        XCTAssertEqual(2, filtered[0])
        XCTAssertEqual(4, filtered[1])
        XCTAssertEqual(6, filtered[2])
    }
}
