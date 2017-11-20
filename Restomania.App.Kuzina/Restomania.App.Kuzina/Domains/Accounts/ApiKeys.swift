//
//  AccessKeys.swift
//  Restomania.App.Kuzina
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
    public var ID: Int64
    public var AccessToken: String

    public init() {
        self.ID = 0
        self.AccessToken = String.empty
    }
    public required init(json: JSON) {
        self.ID = (Keys.id <~~ json)!
        self.AccessToken = (Keys.token <~~ json)!
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.id ~~> self.ID,
            Keys.token ~~> self.AccessToken
        ])
    }
}
