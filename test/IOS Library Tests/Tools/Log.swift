//
//  Fuck.swift
//  IOS library
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//


import IOSLibrary
import XCTest

public class FuckTests: XCTestCase {
    
    public override func setUp() {
        super.setUp()
    }
    
    public override func tearDown() {
        super.tearDown()
    }
    
    public func testFuck() {
        Log.Messages.removeAll()
        
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
    private func CheckMessage(_ expected:LogMessage, _ type:LogMessageType, _ tag: String, _ message:String) -> Void
    {
        XCTAssertEqual(expected.Type, type)
        XCTAssertEqual(expected.Tag, tag)
        XCTAssertEqual(expected.Message, message)
    }
    
}
