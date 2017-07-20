//
//  Fuck.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class LogTests: XCTestCase {
    public override func setUp() {
        super.setUp()

        Log.Messages.removeAll()
        Log.IsDebug = true
    }

    public override func tearDown() {
        super.tearDown()
    }

    public func testLog() {
        let tag = "TAG"
        let message = "MESSAGE"

        Log.Debug(tag, message)
        CheckMessage(Log.Messages.last!, .Debug, tag, message)

        Log.Info(tag, message)
        CheckMessage(Log.Messages.last!, .Info, tag, message)

        Log.Warning(tag, message)
        CheckMessage(Log.Messages.last!, .Warning, tag, message)

        Log.Error(tag, message)
        CheckMessage(Log.Messages.last!, .Error, tag, message)

        XCTAssertEqual(4, Log.Messages.count)
    }
    public func testDebugLog() {
        let tag = "TAG"
        let message = "MESSAGE"

        Log.IsDebug = true
        Log.Debug(tag, message)
        XCTAssertEqual(1, Log.Messages.count)
        Log.Messages.removeAll()

        Log.IsDebug = false
        Log.Debug(tag, message)
        XCTAssertEqual(0, Log.Messages.count)
    }

    private func CheckMessage(_ expected: LogMessage, _ type: LogMessageType, _ tag: String, _ message: String) {
        XCTAssertEqual(expected.Type, type)
        XCTAssertEqual(expected.Tag, tag)
        XCTAssertEqual(expected.Message, message)
    }

}
