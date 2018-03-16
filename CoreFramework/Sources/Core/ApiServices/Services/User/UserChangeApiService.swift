//
//  AccountUpdateUserApiService.swift
//  CoreFramework
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UserChangeApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/Change", type: UserChangeApiService.self, configs: configs, keys: keys)
    }

    public func profile(updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        let parameters = CollectParameters([
                "containers": updates
            ])

        return client.PutBool(action: "Profile", parameters: parameters)
    }
    public func preferences(deviceId: Long, updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        let parameters = CollectParameters([
                "deviceId": deviceId,
                "containers": updates.map({ $0.toJSON() })
            ])

        return client.PutBool(action: "Notifications", parameters: parameters)
    }
}
