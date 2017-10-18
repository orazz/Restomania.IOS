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
    public func anonymous() -> RequestResult<ApiKeys> {

        let parameters = CollectParameters()

        return _client.Post(action: "Anonymous", type: ApiKeys.self, parameters: parameters)
    }
    public func vk(userId: Long, token: String, email: String) -> RequestResult<ApiKeys> {

        let parameters = CollectParameters([
            "userId": userId,
            "token": token,
            "email": email
            ])

        return _client.Post(action: "Vk", type: ApiKeys.self, parameters: parameters)
    }

}
