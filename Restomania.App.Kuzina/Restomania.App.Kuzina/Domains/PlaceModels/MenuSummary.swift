//
//  PlaceMenuSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class MenuSummary: ICached {

    public struct Keys {

        public static let ID = BaseDataType.Keys.ID

        public static let placeId = "PlaceId"
        public static let currency = "Currency"
        public static let categories = "Categories"
        public static let dishes = "Dishes"
    }

    public let ID: Long
    public let placeId: Long
    public let currency: CurrencyType
    public let categories: [MenuCategory]
    public let dishes: [Dish]

    public init() {

        self.ID = 0
        self.placeId = 0
        self.currency = .RUB
        self.categories = [MenuCategory]()
        self.dishes = [Dish]()
    }
    public required init(source: MenuSummary) {

        self.ID = source.ID
        self.placeId = source.placeId
        self.currency = source.currency
        self.categories = source.categories
        self.dishes = source.dishes
    }
    public required init(json: JSON) {

        self.ID = (Keys.ID <~~ json)!
        self.placeId = (Keys.placeId <~~ json)!
        self.currency = (Keys.currency <~~ json)!
        self.categories = (Keys.categories <~~ json)!
        self.dishes = (Keys.dishes <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
                Keys.ID ~~> self.ID,
                Keys.placeId ~~> self.placeId,
                Keys.currency ~~> self.currency,
                Keys.categories ~~> self.categories,
                Keys.dishes ~~> self.dishes
            ])
    }

}
