//
//  AddedOrderDish.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class AddedOrderDish: ICopying, Glossy {

    public struct Keys {
        public static let dishId = "DishId"
        public static let variationId = "VariationId"
        public static let additions = "Additions"
        public static let subdishes = "Subdishes"

        public static let count = "Count"
    }

    public var dishId: Long
    public var variationId: Long?
    public var additions: [Long]
    public var subdishes: [Long]

    public var count: Int

    public init() {

        self.dishId = 0
        self.variationId = nil
        self.additions = []
        self.subdishes = []

        self.count = 0
    }
    public convenience init(dish: Dish, count: Int) {

        self.init()

        self.dishId = dish.ID
        self.count = count
    }

    // MARK: ICopyng
    public required init(source: AddedOrderDish) {

        self.dishId = source.dishId
        self.variationId = source.variationId
        self.additions = source.additions.map { $0 }
        self.subdishes = source.subdishes.map { $0 }

        self.count = source.count
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.dishId = (Keys.dishId <~~ json)!
        self.variationId = Keys.variationId <~~ json
        self.additions = (Keys.additions <~~ json)!
        self.subdishes = (Keys.subdishes <~~ json)!

        self.count = (Keys.count <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.dishId ~~> self.dishId,
            Keys.variationId ~~> self.variationId,
            Keys.additions ~~> self.additions,
            Keys.subdishes ~~> self.subdishes,

            Keys.count ~~> self.count
            ])
    }
}
