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

public class ApiClientTests : XCTestCase
{
    private var _client: ApiClient!
    
    public override func setUp()
    {
        super.setUp()
        
        _client = ApiClient(url: "http://restomania.eu/mvcapi", tag: "TestClient")
    }
    
    public func testSendRequest()
    {
        let task = _client.Get(action: "System/Settings/All", type: Settings.self)
        let result = task.await()
        
        let settings = result.1!
        XCTAssertNotEqual("", settings.HostName)
        XCTAssertNotEqual("", settings.ApiHostName)
        XCTAssertNotEqual("", settings.StatusPath)
        XCTAssertNotEqual("", settings.ReportsPath)
        XCTAssertFalse(settings.Debug)
        
        print(settings)
    }
}
class Settings : Decodable
{
    public let HostName: String
    public let ApiHostName: String
    public let StatusPath: String
    public let ReportsPath: String
    public let Debug: Bool
    
    
    public required init(json:JSON)
    {
        self.HostName = ("HostName" <~~ json)!
        self.ApiHostName = ("ApiHostName" <~~ json)!
        self.StatusPath = ("StatusPath" <~~ json)!
        self.ReportsPath = ("ReportsPath" <~~ json)!
        self.Debug = ("Debug" <~~ json)!
    }
}
