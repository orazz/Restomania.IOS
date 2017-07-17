//
//  Restomania_App_KuzinaTests.swift
//  Restomania.App.KuzinaTests
//
//  Created by Алексей on 10.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import IOSLibrary
@testable import RestomaniaAppKuzina

class Restomania_App_KuzinaTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        TestClass.Hello()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
