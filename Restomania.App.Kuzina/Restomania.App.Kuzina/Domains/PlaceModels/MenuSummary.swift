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

        self.ID = ("ID" <~~ json)!
        self.placeID = ("PlaceID" <~~ json)!
        self.currency = ("Currency" <~~ json)!
        self.categories = ("Categories" <~~ json)!
        self.dishes = ("Dishes" <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
                "ID" ~~> self.ID,
                "PlaceID" ~~> self.placeID,
                "Currency" ~~> self.currency,
                "Categories" ~~> self.categories,
                "Dishes" ~~> self.dishes
            ])
    }

}
