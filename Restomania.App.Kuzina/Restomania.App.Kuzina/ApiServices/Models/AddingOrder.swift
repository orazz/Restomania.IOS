//
//  AddingOrder.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class AddingOrder: Encodable {

    public var PlaceID: Int64
    public var CardID: Int64
    public var CompleteDate: Date
    public var TakeAway: Bool
    public var Dishes: [OrderedDish]
    public var Comment: String
    public var PersonCount: Int

    public init() {
        self.PlaceID = 0
        self.CardID = 0
        self.CompleteDate = Date()
        self.TakeAway = false
        self.Dishes = [OrderedDish]()
        self.Comment = String.Empty
        self.PersonCount = 0
    }

    public func toJSON() -> JSON? {
        return jsonify([
                "PlaceID" ~~> PlaceID,
                "CardID" ~~> CardID,
                "CompleteDate" ~~> CompleteDate,
                "TakeAway" ~~> TakeAway,
                "Dishes" ~~> Dishes,
                "Comment" ~~> Comment,
                "PersonCount" ~~> PersonCount
            ])
    }
}
