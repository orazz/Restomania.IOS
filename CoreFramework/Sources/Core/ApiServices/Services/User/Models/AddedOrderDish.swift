//
//  AddedOrderDish.swift
//  CoreFramework
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class AddedOrderDish: ICopying, Glossy {

    public struct Keys {
        public static let dishId = "DishId"
        public static let variationId = "VariationId"
        public static let addings = "Addings"
        public static let subdishes = "Subdishes"

        public static let count = "Count"
    }

    public fileprivate(set) var dishId: Long
    public fileprivate(set) var variationId: Long?
    public fileprivate(set) var addings: [Long]
    public fileprivate(set) var subdishes: [Long]

    public fileprivate(set) var count: Int

    public init() {

        self.dishId = 0
        self.variationId = nil
        self.addings = []
        self.subdishes = []

        self.count = 0
    }
    public init(_ dishId: Long,
                _ count: Int,
                variationId: Long? = nil,
                additions: [Long] = [],
                subdishes: [Long] = []) {

        self.dishId = dishId
        self.count = count
        self.variationId = variationId
        self.addings = additions
        self.subdishes = subdishes
    }

    // MARK: ICopyng
    public required init(source: AddedOrderDish) {

        self.dishId = source.dishId
        self.variationId = source.variationId
        self.addings = source.addings.map { $0 }
        self.subdishes = source.subdishes.map { $0 }
        self.count = source.count
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.dishId = (Keys.dishId <~~ json)!
        self.variationId = Keys.variationId <~~ json
        self.addings = (Keys.addings <~~ json)!
        self.subdishes = (Keys.subdishes <~~ json)!

        self.count = (Keys.count <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([

            Keys.dishId ~~> self.dishId,
            Keys.variationId ~~> self.variationId,
            Keys.addings ~~> self.addings,
            Keys.subdishes ~~> self.subdishes,

            Keys.count ~~> self.count
            ])
    }
}

extension AddedOrderDish {
    public func increment(_ count: Int = 1) {
        self.count += count
    }
    public func decrement(_ count: Int = 1) {
        self.count = max(0, self.count - count)
    }
    public func total(with menu: MenuSummary) -> Price {

        guard let dish = menu.dishes.find(id: dishId) else {
            return Price.zero
        }

        let result = Price.zero
        switch dish.type {
            case .simpleDish:
                result += dish.price

            case .variableDish:
                if  let variationId = self.variationId,
                     let variation = menu.variations.find(id: variationId) {
                    result += variation.price
                }

            default:
                break
        }

        for adding in addings {
            if let dish = menu.dishes.find(id: adding),
                dish.type == .simpleDish {
                result += dish.price
            }
        }

        return result * count
    }
}
