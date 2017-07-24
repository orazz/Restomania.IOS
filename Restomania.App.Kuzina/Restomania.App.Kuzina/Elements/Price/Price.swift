//
//  Price.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 24.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public class Price {

    public let amount: Double
    public let currency: CurrencyType

    public init(amount: Double, currency: CurrencyType) {

        self.amount = amount
        self.currency = currency
    }
}
