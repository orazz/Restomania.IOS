//
//  SelectParameters.swift
//  FindMe
//
//  Created by Алексей on 26.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class SelectParameters: Glossy {

    public struct Keys {

        public static let time = "Time"
        public static let take = "Take"
        public static let skip = "Skip"
        public static let orderBy = "OrderBy"
    }

    public var time: Date?
    public var take: Int
    public var skip: Int
    public var orderBy: String

    public init(time: Date? = nil) {

        self.time = time
        self.take = 0
        self.skip = 0
        self.orderBy = String.empty
    }

    //MARK: Glossy
    public required init(json: JSON) {

        if let time: String = Keys.time <~~ json {
            self.time = Date.parseJson(value: time)
        }
        else {
            self.time = nil
        }
        self.take = (Keys.take <~~ json)!
        self.skip = (Keys.skip <~~ json)!
        self.orderBy = (Keys.orderBy <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([

            Keys.time ~~> self.time?.prepareForJson(),
            Keys.take ~~> self.take,
            Keys.skip ~~> self.skip,
            Keys.orderBy ~~> self.orderBy
            ])
    }
}
