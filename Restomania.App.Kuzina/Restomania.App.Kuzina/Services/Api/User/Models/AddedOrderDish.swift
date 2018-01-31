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

    public fileprivate(set) var dishId: Long
    public fileprivate(set) var variationId: Long?
    public fileprivate(set) var additions: [Long]
    public fileprivate(set) var subdishes: [Long]

    public fileprivate(set) var count: Int

    public init() {

        self.dishId = 0
        self.variationId = nil
        self.additions = []
        self.subdishes = []

        self.count = 0
    }
    public init(dishId: Long,
                variationId: Long? = nil,
                additions: [Long] = [],
                subdishes: [Long] = []) {

        self.dishId = dishId
        self.variationId = variationId
        self.additions = additions
        self.subdishes = subdishes
        self.count = 1
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

extension AddedOrderDish {
    public func increment() {
        count += 1
    }
    public func decrement() {
        count -= 1
    }
    public func total(with menu: MenuSummary) -> Price {

        guard let dish = menu.dishes.find({ $0.ID == dishId }) else {
            return Price.zero
        }

        let result = Price.zero
        switch dish.type {
            case .simpleDish:
                result += dish.price

            case .variableDish:
                if let variation = menu.variations.find({ $0.ID == variationId }) {
                    result += variation.price
                }

            default:
                break
        }

        for adding in additions {
            if let dish = menu.dishes.find({ $0.ID == adding }),
                dish.type == .simpleDish {
                result += dish.price
            }
        }

        return result
    }
}
