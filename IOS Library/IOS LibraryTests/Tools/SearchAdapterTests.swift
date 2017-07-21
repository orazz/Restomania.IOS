//
//  SearchAdapterTests.swift
//  IOS Library
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class SearchAdapterTests: XCTestCase {

    private var _adapter: SearchAdapter!

    public override func setUp() {
        super.setUp()

        _adapter = SearchAdapter()
    }

    public func testStringFilter() {
        let filter = StringFilter().search

        //True
        XCTAssertEqual(true, filter("ASD", "asd"))
        XCTAssertEqual(true, filter("ASD ", "asd   "))
        XCTAssertEqual(true, filter("ASD 1", "asd &1"))

        XCTAssertEqual(true, filter("ASD 1", "asd #[1]"))
        XCTAssertEqual(true, filter("ASD 1", "asd &1?"))
        XCTAssertEqual(true, filter("ASD 1", "asd &1 ?2"))
        XCTAssertEqual(true, filter("ASD 1", "asd &\\/()!#;:,.[]_+-1():.,.,"))
        XCTAssertEqual(true, filter("1 ASD", "asd &1()"))
        XCTAssertEqual(true, filter("A C", "C B A F"))

        //False
        XCTAssertEqual(false, filter("", 4))
        XCTAssertEqual(false, filter(String.Empty, ""))
        XCTAssertEqual(false, filter("A C T", "C B A F"))
    }
    public func testNumberFilter() {
        let filter = NumberFilter().search

        //True
        XCTAssertEqual(true, filter("1", 123))
        XCTAssertEqual(true, filter("12", 123))
        XCTAssertEqual(true, filter("123", 123))
        XCTAssertEqual(true, filter("12", -123))

        //False
        XCTAssertEqual(false, filter("ASD", String.Empty))
        XCTAssertEqual(false, filter("123", 12))
    }
}
