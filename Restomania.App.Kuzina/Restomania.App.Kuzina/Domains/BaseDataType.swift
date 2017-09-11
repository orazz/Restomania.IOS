//
//  BaseDataType.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class BaseDataType: Glossy {

    public struct Keys {

        public static let ID = "ID"
        public static let CreateAt = "CreateAt"
        public static let UpdateAt = "UpdateAt"
    }

    public var ID: Int64
    public var CreateAt: Date
    public var UpdateAt: Date

    public init() {

        self.ID = 0
        self.CreateAt = Date()
        self.UpdateAt = Date()
    }
    public required init(json: JSON) {

        self.ID = (Keys.ID <~~ json) ?? 0

        if let createAt: String = Keys.CreateAt <~~ json {
            self.CreateAt = Date.parseJson(value: createAt)
        } else {
            self.CreateAt = Date()
        }

        if let updateAt: String = Keys.UpdateAt <~~ json {
            self.UpdateAt = Date.parseJson(value: updateAt)
        } else {
            self.UpdateAt = Date()
        }
    }
    public init(source: BaseDataType) {

        self.ID = source.ID
        self.CreateAt = source.CreateAt
        self.UpdateAt = source.UpdateAt
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.ID ~~> self.ID,
            Keys.CreateAt ~~> self.CreateAt.prepareForJson(),
            Keys.UpdateAt ~~> self.UpdateAt.prepareForJson()
            ])
    }
}
