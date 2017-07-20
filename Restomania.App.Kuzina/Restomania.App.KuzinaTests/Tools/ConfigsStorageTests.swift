//
//  File.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import IOSLibrary
@testable import RestomaniaAppKuzina

public class ConfigsStorageTests: XCTestCase {

    private var _configs: ConfigsStorage!

    override public func setUp() {
        super.setUp()

        _configs = ConfigsStorage(plistName: "Configs")
    }

    public func testGetConfig() {
        let name = _configs.Get(forKey: "Name")

        XCTAssertTrue(name.hasValue)
        XCTAssertEqual("App", name.value as! String)
    }
}
