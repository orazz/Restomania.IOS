//
//  PaymentCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class PaymentCard: BaseDataType, ICached {

    public struct Keys {
        public static let userId = "UserID"
        public static let last4Number = "Last4Number"
        public static let status = "Status"
        public static let type = "Type"
        public static let clientType = "ClientType"
        public static let currency = "Currency"
    }

    public var UserID: Int64
    public var Last4Number: String
    public var Status: PaymentCardStatus
    public var `Type`: PaymentCardType
    public var ClientType: BankClientType
    public var Currency: CurrencyType

    public override init() {

        self.UserID = 0
        self.Last4Number = String.empty
        self.Status = .Proccessing
        self.Type = .Other
        self.ClientType = .TestClient
        self.Currency = .EUR

        super.init()
    }

    // MARK: ICopying
    public required init(source: PaymentCard) {

        self.UserID = source.UserID
        self.Last4Number = source.Last4Number
        self.Status = source.Status
        self.Type = source.Type
        self.ClientType = source.ClientType
        self.Currency = source.Currency

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.UserID = (Keys.userId <~~ json)!
        self.Last4Number = (Keys.last4Number <~~ json)!
        self.Status = (Keys.status <~~ json)!
        self.Type = (Keys.type <~~ json)!
        self.ClientType = (Keys.clientType <~~ json)!
        self.Currency = (Keys.currency <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.userId ~~> self.UserID,
            Keys.last4Number ~~> self.Last4Number,
            Keys.status ~~> self.Status,
            Keys.type ~~> self.Type,
            Keys.clientType ~~> self.ClientType,
            Keys.currency ~~> self.Currency
            ])
    }
}
