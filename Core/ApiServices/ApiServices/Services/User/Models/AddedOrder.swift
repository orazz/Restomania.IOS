//
//  AddedOrder.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class AddedOrder {

    public var userId: Long
    public var placeId: Long
    public var cardId: Long
    public var loyaltyId: Long?
    public var appKey: String

    public var completeAt: Date
    public var comment: String
    public var takeaway: Bool
    public var dishes: [AddedOrderDish]

    public init() {
        self.userId = 0
        self.placeId = 0
        self.cardId = 0
        self.loyaltyId = nil
        self.appKey = String.empty

        self.completeAt = Date()
        self.comment = String.empty
        self.takeaway = false
        self.dishes = []
    }
}

extension AddedOrder: JSONEncodable {
    public struct Keys {
        public static let userId = "UserId"
        public static let placeId = "PlaceId"
        public static let cardId = "CardId"
        public static let loyaltyId = "LoyaltyId"
        public static let appKey = "AppKey"

        public static let completeDate = "CompleteAt"
        public static let comment = "Comment"
        public static let takeaway = "Takeaway"
        public static let dishes = "Dishes"
    }

    public func toJSON() -> JSON? {
        return jsonify([
            Keys.userId ~~> self.userId,
            Keys.placeId ~~> self.placeId,
            Keys.cardId ~~> self.cardId,
            Keys.loyaltyId ~~> self.loyaltyId,
            Keys.appKey ~~> self.appKey,

            Keys.completeDate  ~~> self.completeAt.prepareForJson(),
            Keys.comment ~~> self.comment,
            Keys.takeaway ~~> self.takeaway,
            Keys.dishes ~~> self.dishes
            ])
    }
}
