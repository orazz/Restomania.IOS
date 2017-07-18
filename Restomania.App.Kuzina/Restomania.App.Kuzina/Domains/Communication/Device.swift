//
//  Device.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

public class Device: BaseDataType {

    public let AccountID: Int64
    public let DeviceToken: String
    public let Platform: NotificationPlatformType
    public let RegistrationID: String
    public let Locale: String

    public override init() {
        self.AccountID = 0
        self.DeviceToken = String.Empty
        self.Platform = .Apple
        self.RegistrationID = String.Empty
        self.Locale = "en-US"

        super.init()
    }
    public required init(json: JSON) {
        self.AccountID = ("AccountID" <~~ json)!
        self.DeviceToken = ("DeviceToken" <~~ json)!
        self.Platform = ("Platform" <~~ json)!
        self.RegistrationID = ("RegistrationID" <~~ json)!
        self.Locale = ("Locale" <~~ json)!

        super.init(json: json)
    }
}
