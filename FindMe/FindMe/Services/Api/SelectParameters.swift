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

        public static let take = "Take"
        public static let skip = "Skip"
    }

    public let take: Int
    public let skip: Int

    public init(take: Int = Int.max, skip: Int = 0) {

        self.take = take
        self.skip = skip
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.take = (Keys.take <~~ json)!
        self.skip = (Keys.skip <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
            Keys.take ~~> self.take,
            Keys.skip ~~> self.skip
            ])
    }
}
