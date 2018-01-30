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

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Users", configs: configs, tag: String.tag(UsersMainApiService.self), keys: keys)
    }

    
    //MARK: Methods
    public func find() -> RequestResult<User> {

        let parameters = CollectParameters(rights: .user)

        return client.Get(action: "Find", type: User.self, parameters: parameters)
    }

    public func change(updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "updates": updates
            ])

        return self.client.PutBool(action: "Change", parameters: parameters)
    }
    public func changeAvatar(dataUrl: String) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "dataUrl": dataUrl
            ])

        return self.client.PutBool(action: "ChangeAvatar", parameters: parameters)
    }
    public func checkIn(placeId: Long) -> RequestResult<Bool> {

        let parameters = CollectParameters(rights: .user, [
            "placeID": placeId
        ])

        return client.PostBool(action: "CheckIn", parameters: parameters)
    }
}
