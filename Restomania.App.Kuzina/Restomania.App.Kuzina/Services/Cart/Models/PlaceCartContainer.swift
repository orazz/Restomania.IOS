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

    public var placeID: Long
    public var takeaway: Bool
    public var dishes: [OrderedDish]
    public var comment: String

    internal init(placeID: Long) {

        self.placeID = placeID
        self.takeaway = false
        self.dishes = [OrderedDish]()
        self.comment = String.Empty
    }
    public required init(json: JSON) {

        self.placeID = ("placeID" <~~ json)!
        self.takeaway = ("takeaway" <~~ json)!
        self.dishes = ("dishes" <~~ json)!
        self.comment = ("comment" <~~ json)!
    }

    public func toJSON() -> JSON? {

        return jsonify([
            "placeID" ~~> self.placeID,
            "takeaway" ~~> self.takeaway,
            "dishes" ~~> self.dishes,
            "comment" ~~> self.comment
            ])
    }
}
