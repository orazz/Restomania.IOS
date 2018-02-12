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

public class NotificationsDevicesApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Notifications/Devices", type: NotificationsDevicesApiService.self, configs: configs, keys: keys)
    }

    public func Register(role: ApiRole, token: String, locale: String) -> RequestResult<Device> {
        let parameters = CollectParameters(for: role, [
                "appKey": configs.get(forKey: ConfigKeys.appKey),
                "token": token,
                "platform": NotificationPlatformType.apple.rawValue,
                "locale": locale
            ])

        return client.Post(action: "Register", type: Device.self, parameters: parameters)
    }
}
