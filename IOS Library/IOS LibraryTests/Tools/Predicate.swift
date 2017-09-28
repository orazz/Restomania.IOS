//
//  Predicate.swift
//  IOSLibraryTests
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import XCTest
import Realm
import RealmSwift

public class UserProfile: Object {
    let ids = List<RealmString>()
}
public class RealmString: Object {

    dynamic var stringValue = ""

    public override init(value: Any) {

        super.init(value: [value])
    }

    public required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    public required init() {
        super.init()
    }

    public required init(value: Any, schema: RLMSchema) {
        super.init(value: [value], schema: schema)
    }
}
public class PredicateTests: XCTestCase {


    func buildUser(ids: Int ...) -> UserProfile {

        return UserProfile(value: ["ids": ids.map({ "\($0)" })])
    }
    func prepare(range: [Int]) -> NSPredicate {

        var predicates = [NSPredicate]()
        for id in range {
            predicates.append(NSPredicate(format: "ANY ids.stringValue = '\(id)'"))
        }

        return NSCompoundPredicate.init(type: .and, subpredicates: predicates)
    }

    public func testPredicate() {

        let first = buildUser(ids: 1,2,3)
        let second = buildUser(ids: 2,3)
        let third = buildUser(ids: 3, 1)
        let collection = [first, second, third]

        let predicate = prepare(range: [1,2,3])

        let result = (collection as NSArray).filtered(using: predicate)
        XCTAssertEqual(1, result.count)
    }
}
