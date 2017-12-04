//
//  PlaceCartContainer.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

internal class PlaceCartContainer: Glossy {

    public struct Keys {
        public static let placeId = "placeID"
        public static let dishes = "dishes"
        public static let comment = "comment"
        public static let takeaway = "takeaway"
    }

    public var placeID: Long
    public var takeaway: Bool
    public var dishes: [AddedOrderDish]
    public var comment: String

    internal init(placeID: Long) {

        self.placeID = placeID
        self.takeaway = false
        self.dishes = []
        self.comment = String.empty
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.placeID = (Keys.placeId <~~ json)!
        self.dishes = (Keys.dishes <~~ json)!
        self.comment = (Keys.comment <~~ json)!
        self.takeaway = (Keys.takeaway <~~ json)!
    }
    public func toJSON() -> JSON? {

        return jsonify([
            Keys.placeId ~~> self.placeID,
            Keys.dishes ~~> self.dishes,
            Keys.comment ~~> self.comment,
            Keys.takeaway ~~> self.takeaway
            ])
    }
}
