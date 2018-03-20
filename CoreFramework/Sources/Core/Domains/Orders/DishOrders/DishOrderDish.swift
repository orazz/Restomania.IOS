//
//  OrderedDish.swift
//  CoreFramework
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class DishOrderDish: BaseDataType {

    public struct Keys {
        public static let dishId = "DishId"
        public static let variationId = "VariationId"

        public static let addings = "Addings"
        public static let subdishes = "Subdishes"

        public static let price = "Price"
        public static let count = "Count"
        public static let total = "Total"
        public static let name = "Name"
        public static let type = "Type"
    }

    public var dishId: Long
    public var variationId: Long?

    public var count: Int
    public var name: String
    public var type: DishType
    public var price: Price
    public var total: Price

    public var addings: [AdditionSummary]
    public var subdishes: [SubdishSummary]

    public override init() {

        self.dishId = 0
        self.variationId = nil
        self.addings = []
        self.subdishes = []

        self.price = Price()
        self.count = 0
        self.total = Price()
        self.name = String.empty
        self.type = .simpleDish

        super.init()
    }
    public convenience init(dish: Dish, count: Int) {

        self.init()

        self.dishId = dish.id
        self.count = count
    }

    // MARK: ICopyng
    public required init(source: DishOrderDish) {

        self.dishId = source.dishId
        self.variationId = source.variationId
        self.addings = source.addings.map { AdditionSummary(source: $0) }
        self.subdishes = source.subdishes.map { SubdishSummary(source: $0) }

        self.price = Price(source: source.price)
        self.count = source.count
        self.total = Price(source: source.total)
        self.name = source.name
        self.type = source.type

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.dishId = (Keys.dishId <~~ json)!
        self.variationId = Keys.variationId <~~ json
        self.addings = Keys.addings <~~ json ?? []
        self.subdishes = Keys.subdishes <~~ json ?? []

        self.price = (Keys.price <~~ json)!
        self.count = (Keys.count <~~ json)!
        self.total = Keys.total <~~ json ?? Price()
        self.name = (Keys.name <~~ json)!
        self.type = Keys.type <~~ json ?? .simpleDish

        super.init(json: json)

        if (nil == json[Keys.total]) {
            self.total = Price(double: price.double * count)
        }
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.dishId ~~> self.dishId,
            Keys.variationId ~~> self.variationId,
            Keys.addings ~~> self.addings,
            Keys.subdishes ~~> self.subdishes,

            Keys.price ~~> self.price,
            Keys.count ~~> self.count,
            Keys.total ~~> self.total,
            Keys.name ~~> self.name,
            Keys.type ~~> self.type,

            super.toJSON()
            ])
    }
}
