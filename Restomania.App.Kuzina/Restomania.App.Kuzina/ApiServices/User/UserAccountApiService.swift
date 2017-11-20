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

public class UserAccountApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .user, area: "User/Account", tag: String.tag(UserAccountApiService.self))
    }

    // MARK: Methods
    public func Info() -> RequestResult<User> {
        return _client.Get(action: "Info", type: User.self, parameters: CollectParameters())
    }
}
