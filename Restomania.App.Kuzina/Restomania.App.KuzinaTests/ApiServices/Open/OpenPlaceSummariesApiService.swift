//
//  OpenPlaceSummariesApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import XCTest
import IOSLibrary
import AsyncTask
@testable import RestomaniaAppKuzina

public class OpenPlaceSummariesApiServiceTests: XCTestCase {

    private var _service: OpenPlaceSummariesApiService!

    public override func setUp() {
        super.setUp()

        _service = OpenPlaceSummariesApiService()
    }

    public func testRange() {

        let request = _service.Range(placeIDs: [43, 37, 33, 94])
        let result = request.await()

        let data = result.data!
        XCTAssertEqual(HttpStatusCode.OK, result.statusCode)
        XCTAssertEqual(4, data.count)

    }
}
