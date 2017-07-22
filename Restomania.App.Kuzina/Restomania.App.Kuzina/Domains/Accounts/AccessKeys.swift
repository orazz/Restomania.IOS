//
//  AccessKeys.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class AccessKeys: Glossy {
    public var ID: Int64
    public var AccessToken: String

    public init() {
        self.ID = 0
        self.AccessToken = String.Empty
    }
    public required init(json: JSON) {
        self.ID = ("ID" <~~ json)!
        self.AccessToken = ("AccessToken" <~~ json)!
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "AccessToken" ~~> self.AccessToken
        ])
    }
}
