//
//  CountedLoyaltyDiscounts.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class CountedLoyaltyDiscounts: Decodable {
    public var Bonuses: CountedLoyaltySystem
    public var FixedDiscount: CountedLoyaltySystem
    public var RegularCustomerDiscount: CountedLoyaltySystem

    public init() {
        self.Bonuses = CountedLoyaltySystem()
        self.FixedDiscount = CountedLoyaltySystem()
        self.RegularCustomerDiscount = CountedLoyaltySystem()
    }
    public required init(json: JSON) {
        self.Bonuses = ("Bonuses" <~~ json)!
        self.FixedDiscount = ("FixedDiscount" <~~ json)!
        self.RegularCustomerDiscount = ("RegularCustomerDiscount" <~~ json)!
    }
}
