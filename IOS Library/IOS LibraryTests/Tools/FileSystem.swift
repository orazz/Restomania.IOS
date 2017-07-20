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

        _system.Remove(_file, fromCache: true)
        _system.Remove(_file, fromCache: false)

        _system.Remove(_directory, fromCache: true)
        _system.Remove(_directory, fromCache: false)
    }

//    public func testLoadBundlePlistFile()
//    {
//        //Process
//        let properties = _system.LoadBundlePlist("Root")
//        
//        //Check
//        XCTAssertNotNil(properties)
//        XCTAssertEqual("1", String(describing: properties!["Test"]))
//    }

    public func testIsExist() {
        //Check
        XCTAssertFalse(_system.IsExist(_file, inCache: true))
        XCTAssertFalse(_system.IsExist(_file, inCache: false))

        //Process cache
        _system.SaveTo(_file, data: _data, toCache: true)

        //Check
        XCTAssert(_system.IsExist(_file, inCache: true))
        XCTAssertFalse(_system.IsExist(_file, inCache: false))

        //Process storage
        _system.SaveTo(_file, data: _data, toCache: false)

        //Check
        XCTAssert(_system.IsExist(_file, inCache: true))
        XCTAssert(_system.IsExist(_file, inCache: false))
    }
    public func testCreateDirectory() {
        //Check
        XCTAssertFalse(_system.IsExist(_directory, inCache: true))
        XCTAssertFalse(_system.IsExist(_directory, inCache: true))

        //Process cache
        _system.CreateDirectory(_directory, inCache: true)

        //Check
        XCTAssert(_system.IsExist(_directory, inCache: true))
        XCTAssertFalse(_system.IsExist(_directory, inCache: false))

        //Process storage
        _system.CreateDirectory(_directory, inCache: false)

        //Check
        XCTAssert(_system.IsExist(_directory, inCache: true))
        XCTAssert(_system.IsExist(_directory, inCache: false))
    }
    public func testSaveAndLoad() {
        //Process cache
        _system.SaveTo(_file, data: _data, toCache: true)

        //Check
        XCTAssert(_system.IsExist(_file, inCache: true))
        XCTAssertFalse(_system.IsExist(_file, inCache: false))
        let cacheData = _system.Load(_file, fromCache: true)
        XCTAssertEqual(_data, cacheData)

        let nilData = _system.Load(_file, fromCache: false)
        XCTAssertNil(nilData)

        //Process storage
        _system.SaveTo(_file, data: _data, toCache: false)

        //Check
        XCTAssert(_system.IsExist(_file, inCache: true))
        XCTAssert(_system.IsExist(_file, inCache: false))
        let storageData = _system.Load(_file, fromCache: false)
        XCTAssertEqual(_data, storageData)

        //Process storage with long path
        let path = "\(_directory)/\(_file)"
        _system.CreateDirectory(_directory, inCache: false)
        _system.SaveTo(path, data: _data, toCache: false)

        //Check
        XCTAssert(_system.IsExist(path, inCache: false))
        let data = _system.Load(path, fromCache: false)
        XCTAssertEqual(_data, data)
    }
    public func testRemove() {
        //Initialize
        let path = "\(_directory)/\(_file)"
        _system.CreateDirectory(_directory, inCache: false)
        _system.SaveTo(path, data: _data, toCache: false)
        XCTAssert(_system.IsExist(path, inCache: false))

        //Process
        _system.Remove(path, fromCache: false)
        _system.Remove(path, fromCache: false)

        //Check
        XCTAssertFalse(_system.IsExist(path, inCache: false))
    }
}
