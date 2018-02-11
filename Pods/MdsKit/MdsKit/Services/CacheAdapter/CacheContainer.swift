//
//  CacheContainer.swift
//  MdsKit
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

fileprivate struct Keys {
    public static let data = "data"
    public static let relevanceDate = "relevanceDate"
    public static let freshDate = "freshDate"
    public static let needSaveFreshDate = "needSaveFreshDate"
}
internal class CacheContainer<T: ICached> : ICached {

    public var ID: Long {
        return data.ID
    }
    public private(set) var data: T
    private var relevanceDate: Date
    private var freshDate: Date
    private var needSaveFreshDate: Bool

    public init(data: T, livetime: TimeInterval, freshtime: TimeInterval, needSaveFreshDate: Bool = true) {

        self.data = data
        self.relevanceDate = Date().addingTimeInterval(livetime)
        self.freshDate = Date().addingTimeInterval(freshtime)
        self.needSaveFreshDate = needSaveFreshDate
    }

    public var isRelevance: Bool {
        return 0 < relevanceDate.timeIntervalSince(Date())
    }
    public var isFresh: Bool {
        return 0 < freshDate.timeIntervalSince(Date())
    }

    //MARK: Copying
    public required init(source: CacheContainer<T>) {

        self.data = source.data
        self.relevanceDate = source.relevanceDate
        self.freshDate = source.freshDate
        self.needSaveFreshDate = source.needSaveFreshDate
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.data = (Keys.data <~~ json)!
        self.relevanceDate = Date.parseJson(value: (Keys.relevanceDate <~~ json)! as String)

        if let fresh:String = Keys.freshDate <~~ json {
            self.freshDate = Date.parseJson(value: fresh)
        }
        else {
            self.freshDate = Date()
        }
        self.needSaveFreshDate = Keys.needSaveFreshDate <~~ json ?? false
    }
    public func toJSON() -> JSON? {

        var fields = [
            Keys.data ~~> self.data,
            Keys.relevanceDate ~~> self.relevanceDate.prepareForJson(),
            Keys.needSaveFreshDate ~~> self.needSaveFreshDate
        ]

        if (needSaveFreshDate) {
            fields.append(Keys.freshDate ~~> self.freshDate.prepareForJson())
        }

        return jsonify(fields)
    }
}
