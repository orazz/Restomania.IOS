//
//  Stoplist.swift
//  CoreFramework
//
//  Created by Алексей on 10.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Stoplist: BaseDataType, ICached, PlaceDependentProtocol {
    private struct Keys {
        fileprivate static let placeId = "PlaceId"

        fileprivate static let categories = "Categories"
        fileprivate static let dishes = "Dishes"
    }

    public let placeId: Long

    public let categories: [CategoryStopId]
    public let dishes: [DishStopId]

    public override init() {
        placeId = 0

        categories = []
        dishes = []

        super.init()
    }
    public required init(source: Stoplist) {
        self.placeId = source.placeId

        self.categories = source.categories.map { CategoryStopId(source: $0) }
        self.dishes = source.dishes.map { DishStopId(source: $0) }

        super.init(source: source)
    }
    public required init(json: JSON) {
        self.placeId = (Keys.placeId <~~ json)!

        self.categories = (Keys.categories <~~ json)!
        self.dishes = (Keys.dishes <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.placeId ~~> self.placeId,

            Keys.categories ~~> self.categories,
            Keys.dishes ~~> self.dishes,

            super.toJSON()
            ])
    }
}
