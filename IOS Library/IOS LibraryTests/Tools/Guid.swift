//
//  Guid.swift
//  IOS Library
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
@testable import IOSLibrary

public class GuidTests: XCTestCase {
    public func testGuid() {
        var keys = [String]()
        let size = 100

        for _ in 0...size {
            keys.append(Guid.New)
        }

        for i in 0...size {
            for j in 0...size {
                if (i == j) {
                    continue
                }

                XCTAssertNotEqual(keys[i], keys[j])
            }
        }
    }
}
