//
//  DishOrder.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class DishOrder: BaseDataType, UserDependentProtocol, PlaceDependentProtocol {

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

        public static let isCompleted = "IsCompleted"
        public static let subtotal = "Subtotal"
        public static let discount = "Discount"
        public static let total = "Total"
    }

    public let userId: Long
    public let placeId: Long

    public let cardId: Long?

    public let status: DishOrderStatus
    public let type: DishOrderType
    public let currency: CurrencyType
    public let isPaid: Bool
    public let takeaway: Bool
    public let customData: String?

    public let dishes: [DishOrderDish]
    public let summary: OrderSummary

    public let isCompleted: Bool
    public let subtotal: PriceType
    public let discount: PriceType
    public let total: PriceType

    public override init() {

        self.userId = 0
        self.placeId = 0

        self.cardId = nil

        self.status = .Processing
        self.type = .Remote
        self.currency = .RUB
        self.isPaid = false
        self.takeaway = false
        self.customData = "{}"

        self.dishes = [DishOrderDish]()
        self.summary = OrderSummary()

        self.isCompleted = false
        self.subtotal = PriceType.Zero
        self.discount = PriceType.Zero
        self.total = PriceType.Zero

        super.init()
    }
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

        self.isCompleted = (Keys.isCompleted <~~ json)!
        self.subtotal = (Keys.subtotal <~~ json)!
        self.discount = (Keys.discount <~~ json)!
        self.total = (Keys.total <~~ json)!

        super.init(json: json)
    }
}
