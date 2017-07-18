//
//  BaseLoyaltySystem.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class BaseLoyaltySystem: BaseDataType {
    public var Steps: [Step]
    public var `Type`:LoyaltyType

    public override init() {
        self.Steps = [Step]()
        self.Type = .Bonuses

        super.init()
    }
    public required init(json: JSON) {
        self.Steps = ("Steps" <~~ json) ?? [Step]()
        self.Type = .Bonuses

        super.init(json: json)
    }

    public func Share(sum: Double) -> Double {
        let steps = Steps.sorted(by: {$0.Sum > $1.Sum})

        var totalSteps = [Step]()
        for step in steps {
            if (step.Sum <= sum) {
                totalSteps.append(step)
            }
        }

        if (totalSteps.isEmpty) {
            return 0
        } else {
            return totalSteps.first!.Percent
        }
    }

    internal func BuildCounted(total: Double, discount: Double) -> CountedLoyaltySystem {
        let result = CountedLoyaltySystem()

        result.LoyaltyID = ID
        result.TotalPrice = total
        result.Discount = discount
        result.Type = Type

        return result
    }
}
