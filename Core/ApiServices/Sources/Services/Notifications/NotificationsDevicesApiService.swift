//
//  DevicesOpenApiService.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains
import CoreTools

public class NotificationsDevicesApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "Notifications/Devices", type: NotificationsDevicesApiService.self, configs: configs, keys: keys)
    }

    public func Register(token: String, locale: String) -> RequestResult<Device> {
        let parameters = CollectParameters([
                "appKey": configs.appKey,
                "token": token,
                "platform": NotificationPlatformType.apple.rawValue,
                "locale": locale
            ])

        return client.Post(action: "Register", type: Device.self, parameters: parameters)
    }
}
