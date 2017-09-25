//
//  ApiClient.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import AsyncTask
import Gloss
@testable import IOSLibrary

public class ApiClientTests: XCTestCase {
    private var _client: ApiClient!

    public override func setUp() {
        super.setUp()

        _client = ApiClient(url: "http://restomania.eu/api", tag: "TestClient")
    }

    public func testSendRequestForBool() {
        let task = _client.GetBool(action: "System/Status/IsAlive")
        let result = task.await()

        let status = result.data!
        XCTAssertTrue(status)
    }
    public func testSendRequestForDecodable() {
        let task = _client.Get(action: "System/Settings/All", type: Settings.self)
        let result = task.await()

        let settings = result.data!
        XCTAssertEqual("http://restomania.eu/", settings.HostName)
        XCTAssertEqual("http://restomania.eu/api/", settings.ApiHostName)
        XCTAssertEqual("System/Status/IsAlive", settings.StatusPath)
        XCTAssertEqual("System/Reports/Add", settings.ReportsPath)
        XCTAssertFalse(settings.Debug)
    }
    public func testSendAndGetDate() {
        var components = DateComponents()
        components.year = 2012
        components.month = 7
        components.day = 11
        components.timeZone = TimeZone(identifier: "UTC")
        components.hour = 8
        components.minute = 34
        components.second = 12

        let calendar = Calendar.current
        let date = calendar.date(from: components)!

        var parameters = Parameters()
        parameters["date"] = date.prepareForJson()

        let task = _client.GetString(action: "Admin/Test/TestDate", parameters: parameters)
        let result = task.await()

        XCTAssertEqual(date.prepareForJson(), result.data!)
        XCTAssertTrue(date == Date.parseJson(value: result.data!))
    }
}
class Settings: Gloss.Decodable {
    public let HostName: String
    public let ApiHostName: String
    public let StatusPath: String
    public let ReportsPath: String
    public let Debug: Bool

    public required init(json: JSON) {
        self.HostName = ("HostName" <~~ json)!
        self.ApiHostName = ("ApiHostName" <~~ json)!
        self.StatusPath = ("StatusPath" <~~ json)!
        self.ReportsPath = ("ReportsPath" <~~ json)!
        self.Debug = ("Debug" <~~ json)!
    }
}
