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
        public static let appId = "AppId"

        public static let fcmToken = "FcmToken"
        public static let platform = "Platform"
        public static let locale = "Locale"
    }

    public let accountId: Long?
    public let appId: Long

    public let fcmToken: String
    public let platform: NotificationPlatformType
    public let locale: String

    // MARK: Glossy
    public required init(json: JSON) {

        self.accountId = Keys.accountId <~~ json
        self.appId = (Keys.appId <~~ json)!

        self.fcmToken = (Keys.fcmToken <~~ json)!
        self.platform = (Keys.platform <~~ json)!
        self.locale = (Keys.locale <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.accountId ~~> self.accountId,
            Keys.appId ~~> self.appId,

            Keys.fcmToken ~~> self.fcmToken,
            Keys.platform ~~> self.platform,
            Keys.locale ~~> self.locale
            ])
    }
}
