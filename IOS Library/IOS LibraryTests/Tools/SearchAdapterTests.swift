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

    public func testSearchAdapter() {

        //Initialization
        let adapter = SearchAdapter<Model>()
        adapter.add({ $0.name })
        adapter.add({ $0.surname})
        adapter.add({ $0.age })
        adapter.add({ $0.birthdate }, type: .DateTime)

        let model = Model()
        model.name = "Name Alex"
        model.surname = "Surname Best"
        model.age = 14
        model.birthdate = Date.parseJson(value: "2017-07-21T18:26:00Z")

        //Check
        Check(false, phrase: "test", model: model, adapter: adapter)
        Check(false, phrase: "alexx", model: model, adapter: adapter)
        Check(false, phrase: "15", model: model, adapter: adapter)

        //String
        Check(true, phrase: "name", model: model, adapter: adapter)
        Check(true, phrase: "alex", model: model, adapter: adapter)
        Check(true, phrase: "name alex", model: model, adapter: adapter)
        Check(true, phrase: "surname", model: model, adapter: adapter)
        Check(true, phrase: "best", model: model, adapter: adapter)
        Check(true, phrase: "surname best", model: model, adapter: adapter)
        //Number
        Check(true, phrase: "14", model: model, adapter: adapter)
        //Date
        Check(true, phrase: "07 21", model: model, adapter: adapter)
        Check(true, phrase: "18 26", model: model, adapter: adapter)
        Check(true, phrase: "07", model: model, adapter: adapter)
        Check(true, phrase: "21", model: model, adapter: adapter)
        Check(true, phrase: "18", model: model, adapter: adapter)
        Check(true, phrase: "26", model: model, adapter: adapter)
    }
    public class Model {
        public var name: String
        public var surname: String
        public var age: Int
        public var birthdate: Date

        public init() {
            name = String.Empty
            surname = String.Empty
            age = 0
            birthdate = Date()
        }
    }
    private func Check(_ expected: Bool, phrase: String, model: Model, adapter: SearchAdapter<Model>) {
        XCTAssertEqual(expected, adapter.search(phrase: phrase, in: model))
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

        let filter = DateTimeFilter(type: .Time).search

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

        let filter = DateTimeFilter(type: .Date).search

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

        let filter = DateTimeFilter(type: .DateTime).search

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
