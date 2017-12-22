//
//  CacheContainer.swift
//  IOS Library
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

fileprivate struct Keys {
    public static let data = "data"
    public static let relevanceDate = "relevanceDate"
}
internal class CacheContainer<T: ICached> : ICached {

    public var ID: Long {
        return data.ID
    }
    public private(set) var data: T
    public private(set) var freshDate: Date
    public private(set) var relevanceDate: Date

    public init(data: T, livetime: TimeInterval, freshtime: TimeInterval) {

        self.data = data
        self.relevanceDate = Date().addingTimeInterval(livetime)
        self.freshDate = Date().addingTimeInterval(freshtime)
    }

    //MARK: Copying
    public required init(source: CacheContainer<T>) {

        self.data = source.data
        self.relevanceDate = source.relevanceDate
        self.freshDate = source.freshDate
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.data = (Keys.data <~~ json)!
        self.relevanceDate = Date.parseJson(value: (Keys.relevanceDate <~~ json)! as String)
        self.freshDate = Date()
    }
    public func toJSON() -> JSON? {

        return jsonify([
            Keys.data ~~> self.data,
            Keys.relevanceDate ~~> self.relevanceDate.prepareForJson()
            ])
    }
}
