//
//  Device.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

public class Device: BaseDataType {

    public struct Keys {
        public static let accountId = "AccountID"
        public static let deviceToken = "DeviceToken"
        public static let platform = "Platform"
        public static let registrationId = "RegistrationID"
        public static let locale = "Locale"
    }

    public let AccountID: Int64
    public let DeviceToken: String
    public let Platform: NotificationPlatformType
    public let RegistrationID: String
    public let Locale: String

    public override init() {
        self.AccountID = 0
        self.DeviceToken = String.empty
        self.Platform = .Apple
        self.RegistrationID = String.empty
        self.Locale = "en-US"

        super.init()
    }

    // MARK: Glossy
    public required init(json: JSON) {
        self.AccountID = (Keys.accountId <~~ json)!
        self.DeviceToken = (Keys.deviceToken <~~ json)!
        self.Platform = (Keys.platform <~~ json)!
        self.RegistrationID = (Keys.registrationId <~~ json)!
        self.Locale = (Keys.locale <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.accountId ~~> self.AccountID,
            Keys.deviceToken ~~> self.DeviceToken,
            Keys.platform ~~> self.Platform,
            Keys.registrationId ~~> self.RegistrationID,
            Keys.locale ~~> self.Locale
            ])
    }
}
