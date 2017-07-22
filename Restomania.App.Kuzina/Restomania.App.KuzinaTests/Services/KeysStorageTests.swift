//
//  KeysStorageTests.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import XCTest
@testable import RestomaniaAppKuzina

public class KeysStorageTests: XCTestCase {

    public func testProcessKeys() {
        let manager = ServicesManager()
        let storage = manager.keysStorage as! IKeysCRUDStorage

        //Remove and load
        storage.remove(for: .User)
        storage.remove(for: .Place)
        storage.remove(for: .Admin)

        XCTAssertNil(storage.keysFor(rights: .User))
        XCTAssertNil(storage.keysFor(rights: .Place))
        XCTAssertNil(storage.keysFor(rights: .Admin))

        //Save and load
        let keys = AccessKeys()
        keys.ID = 1241413
        keys.AccessToken = "token"

        storage.set(keys: keys, for: .User)
        let newkeys = storage.keysFor(rights: .User)
        XCTAssertNotNil(newkeys)
        XCTAssertEqual(keys.ID, newkeys!.ID)
        XCTAssertEqual(keys.AccessToken, newkeys!.AccessToken)
    }
}
