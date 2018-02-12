//
//  Device.swift
//  CoreDomains
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class Device: BaseDataType {

    public struct Keys {
        public static let accountId = "AccountId"
        public static let deviceToken = "DeviceToken"
        public static let platform = "Platform"
        public static let registrationId = "RegistrationId"
        public static let locale = "Locale"
    }

    public let AccountId: Int64
    public let DeviceToken: String
    public let Platform: NotificationPlatformType
    public let RegistrationId: String
    public let Locale: String

    public override init() {
        self.AccountId = 0
        self.DeviceToken = String.empty
        self.Platform = .apple
        self.RegistrationId = String.empty
        self.Locale = "en-US"

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {
        self.AccountId = (Keys.accountId <~~ json)!
        self.DeviceToken = (Keys.deviceToken <~~ json)!
        self.Platform = (Keys.platform <~~ json)!
        self.RegistrationId = (Keys.registrationId <~~ json)!
        self.Locale = (Keys.locale <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.accountId ~~> self.AccountId,
            Keys.deviceToken ~~> self.DeviceToken,
            Keys.platform ~~> self.Platform,
            Keys.registrationId ~~> self.RegistrationId,
            Keys.locale ~~> self.Locale
            ])
    }
}
