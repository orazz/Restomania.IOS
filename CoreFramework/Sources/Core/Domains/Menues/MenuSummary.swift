//
//  PlaceMenuSummary.swift
//  CoreDomains
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class MenuSummary: ICached {

    public struct Keys {

        public static let id = BaseDataType.Keys.id

        public static let placeId = "PlaceId"
        public static let currency = "Currency"

        public static let categories = "Categories"

        public static let dishes = "Dishes"
        public static let variations = "Variations"
        public static let addings = "Addings"
        public static let recommendations = "Recommendations"

        public static let stoplist = "Stoplist"
    }

    public let id: Long
    public let placeId: Long
    public let currency: Currency

    public let categories: [MenuCategory]

    public let dishes: [Dish]
    public let variations: [Variation]
    public let addings: [Adding]
    public let recommendations: [Recommendation]

    public let stoplist: Stoplist

    public init() {

        self.id = 0
        self.placeId = 0
        self.currency = .RUB

        self.categories = []

        self.dishes = []
        self.variations = []
        self.addings = []
        self.recommendations = []

        self.stoplist = Stoplist()
    }
    public required init(source: MenuSummary) {

        self.id = source.id
        self.placeId = source.placeId
        self.currency = source.currency

        self.categories = source.categories.map { MenuCategory(source: $0) }

        self.dishes = source.dishes.map { Dish(source: $0) }
        self.variations = source.variations.map { Variation(source: $0) }
        self.addings = source.addings.map { Adding(source: $0) }
        self.recommendations = source.recommendations.map { Recommendation(source: $0) }

        self.stoplist = Stoplist(source: source.stoplist )
    }
    public required init(json: JSON) {

        self.id = (Keys.id <~~ json)!
        self.placeId = (Keys.placeId <~~ json)!
        self.currency = (Keys.currency <~~ json)!

        self.categories = (Keys.categories <~~ json)!

        self.dishes = (Keys.dishes <~~ json)!
        self.variations = (Keys.variations <~~ json)!
        self.addings = (Keys.addings <~~ json)!
        self.recommendations = (Keys.recommendations <~~ json)!

        self.stoplist = (Keys.stoplist <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
                Keys.id ~~> self.id,
                Keys.placeId ~~> self.placeId,
                Keys.currency ~~> self.currency,

                Keys.categories ~~> self.categories,

                Keys.dishes ~~> self.dishes,
                Keys.variations ~~> self.variations,
                Keys.addings ~~> self.addings,
                Keys.recommendations ~~> self.recommendations,

                Keys.stoplist ~~> self.stoplist
            ])
    }
}
