//
//  CountedLoyaltySystem.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class CountedLoyaltySystem: BaseDataType {
    public var Discount: Double
    public var LoyaltyID: Int64
    public var TotalPrice: Double
    public var `Type`: LoyaltyType

    public override init() {
        self.Discount = 0
        self.LoyaltyID = 0
        self.TotalPrice = 0
        self.Type = .Bonuses

        super.init()
    }
    public required init(json: JSON) {
        self.Discount = ("Discount" <~~ json)!
        self.LoyaltyID = ("LoyaltyID" <~~ json)!
        self.TotalPrice = ("TotalPrice" <~~ json)!
        self.Type = ("Type" <~~ json)!

        super.init(json: json)
    }
}
