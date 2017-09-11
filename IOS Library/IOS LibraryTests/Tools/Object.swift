//
//  Object.swift
//  IOS Library
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

import XCTest
@testable import IOSLibrary

public class ObjectExtensionTests: XCTestCase {

    public func testTag() {

        XCTAssertEqual("ObjectExtensionTests", self.getTag())
    }
}
