//
//  UsersChangeApiService.swift
//  FindMe
//
//  Created by Алексей on 13.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class UsersChangeApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: IKeysStorage) {
        super.init(area: "Users/Change", configs: configs, tag: String.tag(UsersMainApiService.self), keys: keys)
    }



    //MARK: Methods
    public func change(updates: [PartialUpdateContainer]) -> RequestResult<Bool> {

        let parameters = self.CollectParameters(rights: .user, [
            "updates": updates
            ])

        return self._client.PutBool(action: "Index", parameters: parameters)
    }
}
