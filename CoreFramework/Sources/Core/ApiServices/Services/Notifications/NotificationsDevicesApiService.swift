//
//  DevicesOpenApiService.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class NotificationsDevicesApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "Notifications/Devices", type: NotificationsDevicesApiService.self, configs: configs, keys: keys)
    }

    public func register(token: String, locale: String) -> RequestResult<Device> {

        let parameters = CollectParameters([
                "appKey": configs.appKey,
                "token": token,
                "platform": NotificationPlatformType.apple.rawValue,
                "locale": locale
            ])

        return client.Post(action: "Register", type: Device.self, parameters: parameters)
    }

    public func update(_ deviceId: Long, token: String) -> RequestResult<Device> {

        let parameters = CollectParameters([
                "deviceId": deviceId,
                "token": token
            ])

        return client.Put(action: "Update", type: Device.self, parameters: parameters)
    }

    public func connect(_ deviceId: Long) -> RequestResult<Device> {

        let parameters = CollectParameters([
                "deviceId": deviceId
            ])

        return client.Put(action: "Connect", type: Device.self, parameters: parameters)
    }
}
