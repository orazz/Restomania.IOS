//
//  AccountUserApiService.swift
//  CoreFramework
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UserAccountApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/Account", type: UserAccountApiService.self, configs: configs, keys: keys)
    }

    // MARK: Methods
    public func info() -> RequestResult<User> {

        let parameters = CollectParameters()

        return client.Get(action: "Info", type: User.self, parameters: parameters)
    }
    public func preferences(deviceId: Long) -> RequestResult<UserNotificationPreference> {
        let parameters = CollectParameters([
            "deviceId": deviceId,
            "method": ConnectionMethod.pushes.rawValue
        ])

        return client.Get(action: "Preferences", type: UserNotificationPreference.self, parameters: parameters)
    }
}
