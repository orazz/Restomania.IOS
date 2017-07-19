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

    public var Dishes: [OrderedDish]
    public var SubTotal: Double
    public var Discount: Double
    public var TotalPrice: Double
    public var Booking: Booking?
    public var Status: DishOrderStatus
    public var `Type`: DishOrderType
    public var TakeAway: Bool
    public var IsPaid: Bool

    public override init() {
        self.Dishes = [OrderedDish]()
        self.SubTotal = 0
        self.Discount = 0
        self.TotalPrice = 0
        self.Booking = nil
        self.Status = .Processing
        self.Type = .Remote
        self.TakeAway = false
        self.IsPaid = false

        super.init()
    }
    public required init(json: JSON) {
        self.Dishes = ("Dishes" <~~ json)!
        self.SubTotal = ("SubTotal" <~~ json)!
        self.Discount = ("Discount" <~~ json)!
        self.TotalPrice = ("TotalPrice" <~~ json)!
        self.Booking = ("Booking" <~~ json)!
        self.Status = ("Status" <~~ json)!
        self.Type = ("Type" <~~ json)!
        self.TakeAway = ("TakeAway" <~~ json)!
        self.IsPaid = ("IsPaid" <~~ json)!

        super.init(json: json)
    }
}
