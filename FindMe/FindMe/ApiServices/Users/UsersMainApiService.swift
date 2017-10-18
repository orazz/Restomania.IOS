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
    public func change(updates:PartialUpdateContainer ...) -> RequestResult<Bool> {

        let parameters = CollectParameters(rights: .user, [
            "updates": updates
            ])

        return _client.PutBool(action: "Change", parameters: parameters)
    }
}
