//
//  SubdishSummary.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class SubdishSummary: ICopying, Glossy {

    public struct Keys {
        public static let id = BaseDataType.Keys.ID
        public static let name = "Name"
        public static let cost = "Cost"
    }

    public var id: Long
    public var name: String
    public var cost: PriceType

    public init() {

        self.id = 0
        self.name = String.empty
        self.cost = PriceType()
    }

    // MARK: ICopying
    public required init(source: SubdishSummary) {

        self.id = source.id
        self.name = source.name
        self.cost = PriceType(source: source.cost)
    }

    // MARK: Glossy
    public required init?(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.cost = (Keys.cost <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.id ~~> self.id,
            Keys.name ~~> self.name,
            Keys.cost ~~> self.cost
            ])
    }
}
