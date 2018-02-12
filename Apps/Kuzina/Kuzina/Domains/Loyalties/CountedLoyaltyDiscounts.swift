//
//  CountedLoyaltyDiscounts.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class CountedLoyaltyDiscounts: JSONDecodable {

    public struct Keys {
        public static let bonuses = "Bonuses"
        public static let fixedDiscount = "FixedDiscount"
        public static let regularCustomerDiscount = "RegularCustomerDiscount"
    }

    public var Bonuses: CountedLoyaltySystem
    public var FixedDiscount: CountedLoyaltySystem
    public var RegularCustomerDiscount: CountedLoyaltySystem

    public init() {
        self.Bonuses = CountedLoyaltySystem()
        self.FixedDiscount = CountedLoyaltySystem()
        self.RegularCustomerDiscount = CountedLoyaltySystem()
    }

    // MARK: Decodable
    public required init(json: JSON) {
        self.Bonuses = (Keys.bonuses <~~ json)!
        self.FixedDiscount = (Keys.fixedDiscount <~~ json)!
        self.RegularCustomerDiscount = (Keys.regularCustomerDiscount <~~ json)!
    }
}
