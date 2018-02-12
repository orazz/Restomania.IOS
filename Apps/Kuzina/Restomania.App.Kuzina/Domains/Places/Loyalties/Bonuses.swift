//
//  Bonuses.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Bonuses: BaseLoyaltySystem {
    public override init() {
        super.init()

        self.Type = .Bonuses
    }
    public required init(json: JSON) {
        super.init(json: json)

        self.Type = .Bonuses
    }

    public func CountDiscount(sum: Double) -> Double {
        return sum * (Share(sum: sum)) / 100
    }
}
