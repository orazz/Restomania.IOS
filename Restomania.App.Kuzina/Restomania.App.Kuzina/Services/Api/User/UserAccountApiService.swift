//
//  AccountUserApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class UserAccountApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "User/Account", tag: String.tag(UserAccountApiService.self), configs: configs, keys: keys)
    }

    // MARK: Methods
    public func Info() -> RequestResult<User> {

        let parameters = CollectParameters(for: .user)

        return _client.Get(action: "Info", type: User.self, parameters: parameters)
    }
}
