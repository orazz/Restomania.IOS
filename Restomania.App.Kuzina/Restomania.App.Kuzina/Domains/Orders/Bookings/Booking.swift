//
//  Booking.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Booking: BaseOrder {

    public var DishOrderID: Int64?
    public var Status: BookingStatus
    public var Table: Int
    public var PersonCount: Int

    public override init() {
        self.DishOrderID = nil
        self.Status = .Processing
        self.Table = 0
        self.PersonCount = 0

        super.init()
    }
    public required init(json: JSON) {
        self.DishOrderID = "DishOrderID" <~~ json
        self.Status = ("Status" <~~ json)!
        self.Table = ("Table" <~~ json)!
        self.PersonCount = ("PersonCount" <~~ json)!

        super.init(json: json)
    }
}
