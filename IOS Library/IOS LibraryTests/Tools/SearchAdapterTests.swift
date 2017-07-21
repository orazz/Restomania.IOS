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
    public func testTimeFilter() {

        let filter = DateFilter(type: .Time).search

        Check(false, phrase: "test", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "14", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "1", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "7", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "21", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "7 21", date: "2017-07-21T18:26:00Z", filter: filter)

        Check(true, phrase: "test 26 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "18 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "18 26", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "26 18", date: "2017-07-21T18:26:00Z", filter: filter)
    }
    public func testDateFilter() {

        let filter = DateFilter(type: .Date).search

        Check(false, phrase: "test", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "14", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "26", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "18", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "18 26", date: "2017-07-21T18:26:00Z", filter: filter)

        Check(true, phrase: "test 21 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "7 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "21 7", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "7 21", date: "2017-07-21T18:26:00Z", filter: filter)
    }
    public func testDateTimeFilter() {

        let filter = DateFilter(type: .DateTime).search

        Check(false, phrase: "test", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "14", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "26 14", date: "2017-07-21T18:26:14Z", filter: filter)
        Check(false, phrase: "21 18", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "21 26", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "21 18", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(false, phrase: "7 18", date: "2017-07-21T18:26:00Z", filter: filter)

        Check(true, phrase: "test 21 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "7 asd", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "18", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "26", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "26 18", date: "2017-07-21T18:26:00Z", filter: filter)
        Check(true, phrase: "21 7", date: "2017-07-21T18:26:00Z", filter: filter)
    }

    private func Check(_ expect: Bool, phrase: String, date: String, filter: (String, Any) -> Bool ) {

        let date = Date.parseJson(value: date)

        XCTAssertEqual(expect, filter(phrase, date))
    }
}
