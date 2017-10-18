//
//  Main.swift
//  FindMe
//
//  Created by Алексей on 05.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class UsersMainApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: IKeysStorage) {
        super.init(area: "Users", configs: configs, tag: String.tag(UsersMainApiService.self), keys: keys)
    }


    
    //MARK: Methods
    public func find() -> RequestResult<User> {

        let parameters = CollectParameters(rights: .user)

        return _client.Get(action: "Find", type: User.self, parameters: parameters)
    }
    public func checkIn(placeId: Long) -> RequestResult<Bool> {

        let parameters = CollectParameters(rights: .user, [
            "placeID": placeId
        ])

        return _client.PostBool(action: "CheckIn", parameters: parameters)
    }
}
