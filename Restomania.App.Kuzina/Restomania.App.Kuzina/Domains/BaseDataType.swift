//
//  BaseDataType.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class BaseDataType: Glossy {
    public var ID: Int64
    public var CreateAt: Date?
    public var UpdateAt: Date?

    public init() {
        self.ID = 0
        self.CreateAt = Date()
        self.UpdateAt = Date()
    }
    public required init(json: JSON) {
        self.ID = ("ID" <~~ json) ?? 0
        self.CreateAt = "CreateAt" <~~ json
        self.UpdateAt = "UpdateAt" <~~ json
    }

    public func toJSON() -> JSON? {
        return jsonify([
            "ID" ~~> self.ID,
            "CreateAt" ~~> self.CreateAt,
            "UpdateAt" ~~> self.UpdateAt
            ])
    }
}
