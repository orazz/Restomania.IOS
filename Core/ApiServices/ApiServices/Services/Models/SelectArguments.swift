//
//  SelectArguments.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class SelectArguments {

    public struct Keys {
        public static let take = "Take"
        public static let skip = "Skip"
    }

    public var take: Int
    public var skip: Int

    public init() {
        self.take = 20
        self.skip = 0
    }
    public convenience init(take: Int = 2147483646, skip: Int = 0) {
        self.init()

        self.take = take
        self.skip = skip
    }

}

// MARK: Encodable
extension SelectArguments: JSONEncodable {

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.skip ~~> skip,
            Keys.time ~~> time?.prepareForJson()
            ])
    }
}
