//
//  TransactionSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class TransactionSummary: Decodable {

    public var `Type`: TransactionType
    public var Status: TransactionStatus
    public var Currency: CurrencyType
    public var Amount: Double
    public var PaymentLink: String

    public init() {
        self.Type = .Quick
        self.Status = .Clean
        self.Currency = .EUR
        self.Amount = 0
        self.PaymentLink = .Empty
    }
    public required init(json: JSON) {
        self.Type = ("Type" <~~ json)!
        self.Status = ("Status" <~~ json)!
        self.Currency = ("Currency" <~~ json)!
        self.Amount = ("Amount" <~~ json)!
        self.PaymentLink = ("PaymentLink" <~~ json)!
    }
}
