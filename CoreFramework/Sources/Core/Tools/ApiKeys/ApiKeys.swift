//
//  ApiKeys.swift
//  CoreTools
//
//  Created by Алексей on 12.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

open class ApiKeys: Glossy {

    private struct Keys {
        public static let id = "ID"
        public static let token = "AccessToken"
    }

    open let id: Long
    open let token: String

    public convenience init() {
        self.init(id: 0, token: String.empty)
    }
    public init(id: Long, token: String) {
        self.id = id
        self.token = token
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

    public var accountId: Long {
        return id
    }
}

public func !=(left: ApiKeys, right: ApiKeys) -> Bool {
    return !(left == right)
}
public func ==(left: ApiKeys, right: ApiKeys) -> Bool {
    return left.id == right.id && left.token == right.token
}
