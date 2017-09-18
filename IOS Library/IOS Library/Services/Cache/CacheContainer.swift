//
//  CacheContainer.swift
//  IOS Library
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

internal class CacheContainer<T: ICached> : ICached {

    public var ID: Long {
        return data.ID
    }
    public var data: T
    public var relevanceDate: Date

    public init(data: T, livetime: TimeInterval) {

        self.data = data
        self.relevanceDate = Date().addingTimeInterval(livetime)
    }
    public required init(source: CacheContainer<T>) {

        self.data = source.data
        self.relevanceDate = source.relevanceDate
    }
    public required init(json: JSON) {

        self.data = ("data" <~~ json)!
        self.relevanceDate = Date.parseJson(value: ("relevanceDate" <~~ json)! as String)
    }

    public func toJSON() -> JSON? {

        return jsonify([
            "data" ~~> self.data,
            "relevanceDate" ~~> self.relevanceDate.prepareForJson()
            ])
    }
}
