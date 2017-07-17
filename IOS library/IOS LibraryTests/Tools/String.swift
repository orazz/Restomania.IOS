//
//  String.swift
//  IOS Library
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class StringTests
{
    public func testString()
    {
        XCTAssertEqual("", String.Empty)
        
        XCTAssertTrue(String.IsNullOrEmpty(""))
        XCTAssertTrue(String.IsNullOrEmpty(nil))
        
        XCTAssertFalse(String.IsNullOrEmpty("Test"))
    }
}
