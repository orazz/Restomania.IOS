//
//  Auth.swift
//  FindMe
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class UsersAuthApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Users/Auth", configs: configs, tag: String.tag(UsersAuthApiService.self))
    }

    //MARK: Methods
    public func vk(userId: Long, token: String, expireIn: Long) -> RequestResult<ApiKeys> {

        let parameters = CollectParameters([
            "userId": userId,
            "token": token,
            "expireIn": expireIn
            ])

        return _client.Post(action: "Vk", type: ApiKeys.self, parameters: parameters)
    }

}
