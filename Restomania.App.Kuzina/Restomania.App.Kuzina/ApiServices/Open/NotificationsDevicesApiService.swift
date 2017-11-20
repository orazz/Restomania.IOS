//
//  DevicesOpenApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class NotificationsDevicesApiService: BaseApiService {

    public init() {
        super.init(area: "Notifications/Devices", tag: String.tag(NotificationsDevicesApiService.self))
    }

    public func Register(keys: ApiKeys, token: String, locale: String) -> RequestResult<Device> {
        let parameters = CollectParameters([
            "keys": keys,
            "token": token,
            "platform": NotificationPlatformType.apple.rawValue,
            "locale": locale
            ])

        return _client.Post(action: "Register", type: Device.self, parameters: parameters)
    }
}
