//
//  GetArgs.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class GetArgs {

    public struct Keys {
        public static let take = "Take"
        public static let skip = "Skip"
        public static let time = "Time"
    }

    public var take: Int
    public var skip: Int
    public var time: Date?

    public init() {
        self.take = 20
        self.skip = 0
        self.time = nil
    }
    public convenience init(take: Int, skip: Int = 0, time: Date? = nil) {
        self.init()

        self.take = take
        self.skip = skip
        self.time = time
    }

}

// MARK: Encodable
extension GetArgs: JSONEncodable {

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.time ~~> take,
            Keys.skip ~~> skip,
            Keys.time ~~> time?.prepareForJson()
            ])
    }
}