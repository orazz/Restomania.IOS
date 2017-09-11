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
        public static let PlaceID = "PlaceID"
        public static let Currency = "Currency"
        public static let Categories = "Categories"
        public static let Dishes = "Dishes"
    }

    public let ID: Long
    public let placeID: Long
    public let currency: CurrencyType
    public let categories: [DishCategory]
    public let dishes: [Dish]

    public init() {

        self.ID = 0
        self.placeID = 0
        self.currency = .RUB
        self.categories = [DishCategory]()
        self.dishes = [Dish]()
    }
    public required init(source: MenuSummary) {

        self.ID = source.ID
        self.placeID = source.placeID
        self.currency = source.currency
        self.categories = source.categories
        self.dishes = source.dishes
    }
    public required init(json: JSON) {

        self.ID = (Keys.ID <~~ json)!
        self.placeID = (Keys.PlaceID <~~ json)!
        self.currency = (Keys.PlaceID <~~ json)!
        self.categories = (Keys.Categories <~~ json)!
        self.dishes = (Keys.Dishes <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
                Keys.ID ~~> self.ID,
                Keys.PlaceID ~~> self.placeID,
                Keys.Currency ~~> self.currency,
                Keys.Categories ~~> self.categories,
                Keys.Dishes ~~> self.dishes
            ])
    }

}
