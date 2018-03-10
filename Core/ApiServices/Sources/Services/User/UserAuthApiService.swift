//
//  UserAuthApiService.swift
//  CoreApiServices
//
//  Created by Алексей on 11.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreTools

public class UserAuthApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/Auth", type: UserAuthApiService.self, configs: configs, keys: keys)
    }

    public func viaVk(_ userId: Long, token: String) -> RequestResult<ApiKeys> {

        let parameters = CollectParameters([
                "vkUserId": userId,
                "token": token
            ])

        return client.Post(action: "Vk", type: ApiKeys.self, parameters: parameters)
    }
    public func viaInstagram(token: String) -> RequestResult<ApiKeys> {

        let parameters = CollectParameters([
                "token": token
            ])

        return client.Post(action: "Instagram", type: ApiKeys.self, parameters: parameters)
    }
    public func viaPhone(token: String) -> RequestResult<ApiKeys> {

        let parameters = CollectParameters([
                "appKey": configs.appKey,
                "refreshToken": token
            ])

        return client.Post(action: "Phone", type: ApiKeys.self, parameters: parameters)
    }
}
