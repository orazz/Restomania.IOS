//
//  TransactionSummary.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class TransactionSummary: Gloss.Decodable {

    public struct Keys {
        public static let type = "Type"
        public static let status = "Status"
        public static let currency = "Currency"
        public static let amount = "Amount"
        public static let paymentLink = "PaymentLink"
    }

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
        self.PaymentLink = String.empty
    }

    // MARK: Decodable
    public required init(json: JSON) {

        self.Type = (Keys.type <~~ json)!
        self.Status = (Keys.status <~~ json)!
        self.Currency = (Keys.currency <~~ json)!
        self.Amount = (Keys.amount <~~ json)!
        self.PaymentLink = (Keys.paymentLink <~~ json)!
    }
}
