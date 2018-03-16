//
//  UserNotificationPreference.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class UserNotificationPreference: BaseNotificationPreference {

    public class Keys: BaseNotificationPreference.BaseKeys {
        
        public static let dishOrderIsPrepared = "DishOrderIsPrepared"
        public static let paymentCardAdd = "PaymentCardAdd"
    }

    public let ordersIsPrepared: Bool

    public let paymentCardAdd: Bool

    public override init() {

        self.ordersIsPrepared = false
        self.paymentCardAdd = false

        super.init()
    }
    public required init(json: JSON) {

        self.ordersIsPrepared = (Keys.dishOrderIsPrepared <~~ json)!
        self.paymentCardAdd = (Keys.paymentCardAdd <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.dishOrderIsPrepared ~~> self.ordersIsPrepared,
            Keys.paymentCardAdd ~~> self.paymentCardAdd,

            super.toJSON()
            ])
    }
}
