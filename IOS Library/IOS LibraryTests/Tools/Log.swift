//
//  LogTests.swift
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

        Log.messages.removeAll()
        Log.isDebug = true
    }

    public override func tearDown() {
        super.tearDown()
    }

    public func testLog() {
        let tag = "TAG"
        let message = "MESSAGE"

        Log.debug(tag, message)
        CheckMessage(Log.messages.last!, .debug, tag, message)

        Log.info(tag, message)
        CheckMessage(Log.messages.last!, .info, tag, message)

        Log.warning(tag, message)
        CheckMessage(Log.messages.last!, .warning, tag, message)

        Log.error(tag, message)
        CheckMessage(Log.messages.last!, .error, tag, message)

        XCTAssertEqual(4, Log.messages.count)
    }
    public func testDebugLog() {
        let tag = "TAG"
        let message = "MESSAGE"

        Log.isDebug = true
        Log.debug(tag, message)
        XCTAssertEqual(1, Log.messages.count)
        Log.messages.removeAll()

        Log.isDebug = false
        Log.debug(tag, message)
        XCTAssertEqual(0, Log.messages.count)
    }

    private func CheckMessage(_ expected: LogMessage, _ type: LogMessageType, _ tag: String, _ message: String) {
        XCTAssertEqual(expected.Type, type)
        XCTAssertEqual(expected.Tag, tag)
        XCTAssertEqual(expected.Message, message)
    }

}
