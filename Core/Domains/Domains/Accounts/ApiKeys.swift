//
//  AccessKeys.swift
//  CoreDomains
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class ApiKeys: Glossy {

    public struct Keys {
        public static let id = "ID"
        public static let token = "AccessToken"
    }
    public var id: Int64
    public var token: String

    public init() {
        self.id = 0
        self.token = String.empty
    }
    public required init(json: JSON) {
        self.id = (Keys.id <~~ json)!
        self.token = (Keys.token <~~ json)!
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.id,
            Keys.token ~~> self.token
        ])
    }
}

public func !=(left: ApiKeys, right: ApiKeys) -> Bool {
    return !(left == right)
}
public func ==(left: ApiKeys, right: ApiKeys) -> Bool {
    return left.id == right.id && left.token == right.token
}
