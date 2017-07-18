//
//  LoyaltyAccount.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class LoyaltyAccount: BaseDataType {
    public var UserID: Int64
    public var PlaceID: Int64
    public var Bonuses: Double
    public var LastMonthSum: Double

    public override init() {
        self.UserID = 0
        self.PlaceID = 0
        self.Bonuses = 0
        self.LastMonthSum = 0

        super.init()
    }
    public required init(json: JSON) {
        self.UserID = ("UserID" <~~ json)!
        self.PlaceID = ("PlaceID" <~~ json)!
        self.Bonuses = ("Bonuses" <~~ json)!
        self.LastMonthSum = ("LastMonthSum" <~~ json)!

        super.init(json: json)
    }
}
