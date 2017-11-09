//
//  DishOrder.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class DishOrder: BaseOrder {

    public struct Keys {

        public static let dishes = "Dishes"
        public static let subtotal = "SubTotal"
        public static let discount = "Discount"
        public static let totalPrice = "TotalPrice"
        public static let status = "Status"
        public static let type = "Type"
        public static let takeaway = "TakeAway"
        public static let isPaid = "IsPaid"
    }

    public var Dishes: [OrderedDish]
    public var SubTotal: Double
    public var Discount: Double
    public var TotalPrice: Double
//    public var Booking: Booking?
    public var Status: DishOrderStatus
    public var `Type`: DishOrderType
    public var TakeAway: Bool
    public var IsPaid: Bool

    public var isCompleted: Bool {

        return self.Status == .CanceledByPlace ||
            self.Status == .CanceledByUser ||
            self.Status == .PaymentFail ||
            self.Status == .Completed
    }

    public override init() {
        self.Dishes = [OrderedDish]()
        self.SubTotal = 0
        self.Discount = 0
        self.TotalPrice = 0
//        self.Booking = nil
        self.Status = .Processing
        self.Type = .Remote
        self.TakeAway = false
        self.IsPaid = false

        super.init()
    }
    public required init(json: JSON) {
        self.Dishes = (Keys.dishes <~~ json)!
        self.SubTotal = (Keys.subtotal <~~ json)!
        self.Discount = (Keys.discount <~~ json)!
        self.TotalPrice = (Keys.totalPrice <~~ json)!
//        self.Booking = ("Booking" <~~ json)!
        self.Status = (Keys.status <~~ json)!
        self.Type = (Keys.type <~~ json)!
        self.TakeAway = (Keys.takeaway <~~ json)!
        self.IsPaid = (Keys.isPaid <~~ json)!

        super.init(json: json)
    }
}
