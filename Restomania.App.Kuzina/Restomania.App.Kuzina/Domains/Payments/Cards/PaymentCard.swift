//
//  PaymentCard.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class PaymentCard: BaseDataType {

    public var UserID: Int64
    public var Last4Number: String
    public var Status: PaymentCardStatus
    public var `Type`: PaymentCardType
    public var ClientType: BankClientType
    public var Currency: CurrencyType

    public override init() {
        self.UserID = 0
        self.Last4Number = String.Empty
        self.Status = .Proccessing
        self.Type = .Other
        self.ClientType = .TestClient
        self.Currency = .EUR

        super.init()
    }
    public required init(json: JSON) {
        self.UserID = ("UserID" <~~ json)!
        self.Last4Number = ("Last4Number" <~~ json)!
        self.Status = ("Status" <~~ json)!
        self.Type = ("Type" <~~ json)!
        self.ClientType = ("ClientType" <~~ json)!
        self.Currency = ("Currency" <~~ json)!

        super.init(json: json)
    }
}
