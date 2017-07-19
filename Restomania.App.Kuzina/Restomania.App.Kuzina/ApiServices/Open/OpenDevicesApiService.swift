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

public class OpenDevicesApiService: BaseApiService {

    public init() {
        super.init(area: "Open/Devices", tag: "OpenDevicesApiService")
    }

    public func Register(keys: AccessKeys, token: String, platform: NotificationPlatformType, locale: String) -> RequestResult<Device> {
        let parameters = CollectParameters([
            "keys": keys,
            "token": token,
            "platform": platform,
            "locale": locale
            ])

        return _client.Post(action: "Register", type: Device.self, parameters: parameters)
    }
}
