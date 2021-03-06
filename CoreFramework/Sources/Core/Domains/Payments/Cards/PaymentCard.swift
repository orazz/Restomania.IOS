//
//  PaymentCard.swift
//  CoreDomains
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PaymentCard: BaseDataType, ICached {

    public struct Keys {
        public static let userId = "UserID"
        public static let last4Number = "Last4Number"
        public static let status = "Status"
        public static let type = "Type"
        public static let clientType = "PaymentClient"
        public static let currency = "Currency"
    }

    public var userId: Long
    public var last4Number: String
    public var status: PaymentCardStatus
    public var type: PaymentCardType
    public var paymentSystem: PaymentSystem
    public var currency: Currency

    public override init() {

        self.userId = 0
        self.last4Number = String.empty
        self.status = .Proccessing
        self.type = .Other
        self.paymentSystem = .sandbox
        self.currency = .EUR

        super.init()
    }

    // MARK: ICopying
    public required init(source: PaymentCard) {

        self.userId = source.userId
        self.last4Number = source.last4Number
        self.status = source.status
        self.type = source.type
        self.paymentSystem = source.paymentSystem
        self.currency = source.currency

        super.init(source: source)
    }

    // MARK: Glossy
    public required init(json: JSON) {

        self.userId = (Keys.userId <~~ json)!
        self.last4Number = (Keys.last4Number <~~ json)!
        self.status = (Keys.status <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.paymentSystem = (Keys.clientType <~~ json)!
        self.currency = (Keys.currency <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.userId ~~> self.userId,
            Keys.last4Number ~~> self.last4Number,
            Keys.status ~~> self.status,
            Keys.type ~~> self.type,
            Keys.clientType ~~> self.paymentSystem,
            Keys.currency ~~> self.currency
            ])
    }
}
