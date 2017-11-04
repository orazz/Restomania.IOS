//
//  AddingOrder.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class AddingOrder: Gloss.Encodable {

    public struct Keys {
        public static let placeId = "PlaceID"
        public static let cardId = "CardID"
        public static let completeDate = "CompleteDate"
        public static let takeAway = "TakeAway"
        public static let dishes = "Dishes"
        public static let comment = "Comment"
        public static let personCount = "PersonCount"
    }

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
        self.Comment = String.empty
        self.PersonCount = 0
    }

    // MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                Keys.placeId ~~> PlaceID,
                Keys.cardId ~~> CardID,
                Keys.completeDate  ~~> CompleteDate.prepareForJson(),
                Keys.takeAway ~~> TakeAway,
                Keys.dishes ~~> Dishes,
                Keys.comment ~~> Comment,
                Keys.personCount ~~> PersonCount
            ])
    }
}
