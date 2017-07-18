//
//  Loyalty.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PlaceLoyalty: BaseDataType {
    public var bonuses: Bonuses
    public var regularCustomerDiscount: RegularCustomerDiscount
    public var fixedDiscount: FixedDiscount

    public override init() {
        bonuses = Bonuses()
        regularCustomerDiscount = RegularCustomerDiscount()
        fixedDiscount = FixedDiscount()

        super.init()
    }
    public required init(json: JSON) {
        bonuses = ("Bonuses" <~~ json) ?? Bonuses()
        regularCustomerDiscount = ("RegularCustomerDiscount" <~~ json) ?? RegularCustomerDiscount()
        fixedDiscount = ("FixedDiscount" <~~ json) ?? FixedDiscount()

        super.init(json: json)
    }
}
