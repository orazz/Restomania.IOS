//
//  BaseNotificationPreference.swift
//  CoreDomains
//
//  Created by Алексей on 17.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class BaseNotificationPreference: BaseDataType {

    public class BaseKeys {

        public static let login = "Login"
        public static let connectionMethod = "ConnectionMethod"

        public static let bookingAdd = "BookingAdd"
        public static let bookingChangeStatus = "BookingChangeStatus"

        public static let dishOrderAdd = "DishOrderAdd"
        public static let dishOrderChangeStatus = "DishOrderChangeStatus"
        public static let dishOrderPaymentComplete = "DishOrderPaymentComplete"
        public static let dishOrderPaymentFail = "DishOrderPaymentFail"

        public static let reviewAdd = "ReviewAdd"
        public static let reviewChange = "ReviewChange"
        public static let reviewChangeStatus = "ReviewChangeStatus"
    }

    public let login: String
    public let connectionMethod: ConnectionMethod

    public let bookingAdd: Bool
    public let bookingChangeStatus: Bool

    public let ordersAdd: Bool
    public let ordersChangeStatus: Bool
    public let ordersPaymentComplete: Bool
    public let ordersPaymentFail: Bool

    public let reviewAdd: Bool
    public let reviewChange: Bool
    public let reviewChangeStatus: Bool


    public override init() {

        self.login = String.empty
        self.connectionMethod = .debug

        self.bookingAdd = false
        self.bookingChangeStatus = false

        self.ordersAdd = false
        self.ordersChangeStatus = false
        self.ordersPaymentComplete = false
        self.ordersPaymentFail = false

        self.reviewAdd = false
        self.reviewChange = false
        self.reviewChangeStatus = false

        super.init()
    }
    public required init(json: JSON) {

        self.login = (BaseKeys.login <~~ json)!
        self.connectionMethod = (BaseKeys.connectionMethod <~~ json)!

        self.bookingAdd = (BaseKeys.bookingAdd <~~ json)!
        self.bookingChangeStatus = (BaseKeys.bookingChangeStatus <~~ json)!

        self.ordersAdd = (BaseKeys.dishOrderAdd <~~ json)!
        self.ordersChangeStatus = (BaseKeys.dishOrderChangeStatus <~~ json)!
        self.ordersPaymentComplete = (BaseKeys.dishOrderPaymentComplete <~~ json)!
        self.ordersPaymentFail = (BaseKeys.dishOrderPaymentFail <~~ json)!

        self.reviewAdd = (BaseKeys.reviewAdd <~~ json)!
        self.reviewChange = (BaseKeys.reviewChange <~~ json)!
        self.reviewChangeStatus = (BaseKeys.reviewChangeStatus <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            BaseKeys.login ~~> self.login,
            BaseKeys.connectionMethod ~~> self.connectionMethod,

            BaseKeys.bookingAdd ~~> self.bookingAdd,
            BaseKeys.bookingChangeStatus ~~> self.bookingChangeStatus,

            BaseKeys.dishOrderAdd ~~> self.ordersAdd,
            BaseKeys.dishOrderChangeStatus ~~> self.ordersChangeStatus,
            BaseKeys.dishOrderPaymentComplete ~~> self.ordersPaymentComplete,
            BaseKeys.dishOrderPaymentFail ~~> self.ordersPaymentFail,

            BaseKeys.reviewAdd ~~> self.reviewAdd,
            BaseKeys.reviewChange ~~> self.reviewChange,
            BaseKeys.reviewChangeStatus ~~> self.reviewChangeStatus,

            super.toJSON()
            ])
    }
}
