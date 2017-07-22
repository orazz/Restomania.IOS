//
//  FileSystem.swift
//  IOS Library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class FileSystemTests: XCTestCase {
    private let _directory = "testDir/magic"
    private let _file = "file.json"
    private let _data = "{a:123, b:\"test\"}"

    private var _system: FileSystem!

    public override func setUp() {
        super.setUp()

        Reset()
    }
    public override func tearDown() {
        super.tearDown()

        Reset()
    }
    private func Reset() {
        _system = FileSystem()

        _system.remove(_file, fromCache: true)
        _system.remove(_file, fromCache: false)

        _system.remove(_directory, fromCache: true)
        _system.remove(_directory, fromCache: false)
    }

    public func testIsExist() {
        //Check
        XCTAssertFalse(_system.isExist(_file, inCache: true))
        XCTAssertFalse(_system.isExist(_file, inCache: false))

        //Process cache
        _system.saveTo(_file, data: _data, toCache: true)

        //Check
        XCTAssert(_system.isExist(_file, inCache: true))
        XCTAssertFalse(_system.isExist(_file, inCache: false))

        //Process storage
        _system.saveTo(_file, data: _data, toCache: false)

        //Check
        XCTAssert(_system.isExist(_file, inCache: true))
        XCTAssert(_system.isExist(_file, inCache: false))
    }
    public func testCreateDirectory() {
        //Check
        XCTAssertFalse(_system.isExist(_directory, inCache: true))
        XCTAssertFalse(_system.isExist(_directory, inCache: true))

        //Process cache
        _system.createDirectory(_directory, inCache: true)

        //Check
        XCTAssert(_system.isExist(_directory, inCache: true))
        XCTAssertFalse(_system.isExist(_directory, inCache: false))

        //Process storage
        _system.createDirectory(_directory, inCache: false)

        //Check
        XCTAssert(_system.isExist(_directory, inCache: true))
        XCTAssert(_system.isExist(_directory, inCache: false))
    }
    public func testSaveAndLoad() {
        //Process cache
        _system.saveTo(_file, data: _data, toCache: true)

        //Check
        XCTAssert(_system.isExist(_file, inCache: true))
        XCTAssertFalse(_system.isExist(_file, inCache: false))
        let cacheData = _system.load(_file, fromCache: true)
        XCTAssertEqual(_data, cacheData)

        let nilData = _system.load(_file, fromCache: false)
        XCTAssertNil(nilData)

        //Process storage
        _system.saveTo(_file, data: _data, toCache: false)

        //Check
        XCTAssert(_system.isExist(_file, inCache: true))
        XCTAssert(_system.isExist(_file, inCache: false))
        let storageData = _system.load(_file, fromCache: false)
        XCTAssertEqual(_data, storageData)

        //Process storage with long path
        let path = "\(_directory)/\(_file)"
        _system.createDirectory(_directory, inCache: false)
        _system.saveTo(path, data: _data, toCache: false)

        //Check
        XCTAssert(_system.isExist(path, inCache: false))
        let data = _system.load(path, fromCache: false)
        XCTAssertEqual(_data, data)
    }
    public func testRemove() {
        //Initialize
        let path = "\(_directory)/\(_file)"
        _system.createDirectory(_directory, inCache: false)
        _system.saveTo(path, data: _data, toCache: false)
        XCTAssert(_system.isExist(path, inCache: false))

        //Process
        _system.remove(path, fromCache: false)
        _system.remove(path, fromCache: false)

        //Check
        XCTAssertFalse(_system.isExist(path, inCache: false))
    }
}
