//
//  RegularCustomerDiscount.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class RegularCustomerDiscount: BaseLoyaltySystem {
    public override init() {
        super.init()

        self.Type = .RegularCustomerDiscount
    }
    public required init(json: JSON) {
        super.init(json: json)

        self.Type = .RegularCustomerDiscount
    }

    public func CountDiscount(sum: Double, lastMonthSum: Double) -> Double {
        return sum * (Share(sum: lastMonthSum)) / 100
    }
}
