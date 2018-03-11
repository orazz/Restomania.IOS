//
//  DishOrder.swift
//  CoreDomains
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class DishOrder: BaseDataType, ICached, UserDependentProtocol, PlaceDependentProtocol {

    public struct Keys {

        public static let userId = "UserId"
        public static let placeId = "PlaceId"

        public static let cardId = "CardId"

        public static let status = "Status"
        public static let type = "Type"
        public static let currency = "Currency"
        public static let isPaid = "IsPaid"
        public static let takeaway = "Takeaway"
        public static let customData = "CustomData"

        public static let dishes = "Dishes"
        public static let summary = "Summary"

        public static let subtotal = "Subtotal"
        public static let discount = "Discount"
        public static let total = "Total"
    }

    public let userId: Long
    public let placeId: Long

    public let cardId: Long?

    public var status: DishOrderStatus
    public let type: DishOrderType
    public let currency: Currency
    public let isPaid: Bool
    public let takeaway: Bool
    public let customData: String?

    public let dishes: [DishOrderDish]
    public let summary: OrderSummary

    public let subtotal: Price
    public let discount: Price
    public let total: Price

    public override init() {

        self.userId = 0
        self.placeId = 0

        self.cardId = nil

        self.status = .processing
        self.type = .Remote
        self.currency = .RUB
        self.isPaid = false
        self.takeaway = false
        self.customData = "{}"

        self.dishes = [DishOrderDish]()
        self.summary = OrderSummary()

        self.subtotal = Price.zero
        self.discount = Price.zero
        self.total = Price.zero

        super.init()
    }
    // MARK: ICopying
    public required init(source: DishOrder) {

        self.userId = source.userId
        self.placeId = source.placeId

        self.cardId = source.cardId

        self.status = source.status
        self.type = source.type
        self.currency = source.currency
        self.isPaid = source.isPaid
        self.takeaway = source.takeaway
        self.customData = source.customData

        self.dishes = source.dishes
        self.summary = source.summary

        self.subtotal = source.subtotal
        self.discount = source.discount
        self.total = source.total

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.userId = (Keys.userId <~~ json)!
        self.placeId = (Keys.placeId <~~ json)!

        self.cardId = Keys.cardId <~~ json

        self.status = (Keys.status <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.currency = (Keys.currency <~~ json)!
        self.isPaid = (Keys.isPaid <~~ json)!
        self.takeaway = (Keys.takeaway <~~ json)!
        self.customData = Keys.customData <~~ json

        self.dishes = (Keys.dishes <~~ json)!
        self.summary = (Keys.summary <~~ json)!

        self.subtotal = (Keys.subtotal <~~ json)!
        self.discount = (Keys.discount <~~ json)!
        self.total = (Keys.total <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.userId ~~> self.userId,
            Keys.placeId ~~> self.placeId,

            Keys.cardId ~~> self.cardId,

            Keys.status ~~> self.status,
            Keys.type ~~> self.type,
            Keys.currency ~~> self.currency,
            Keys.isPaid ~~> self.isPaid,
            Keys.takeaway ~~> self.takeaway,
            Keys.customData ~~> self.customData,

            Keys.dishes ~~> self.dishes,
            Keys.summary ~~> self.summary,

            Keys.subtotal ~~> self.subtotal,
            Keys.discount ~~> self.discount,
            Keys.total ~~> self.total
            ])
    }
}
extension DishOrder {
    public var isCompleted: Bool {
        return status == .canceledByPlace ||
            status == .canceledByUser ||
            status == .paymentFail ||
            status == .completed
    }
}
