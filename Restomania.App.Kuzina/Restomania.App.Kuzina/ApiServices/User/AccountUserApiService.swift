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

public class AccountOpenApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/Account", tag: "AccountsOpenApiService")
    }

    public func Info() -> Task<RequestResult<User>> {
        return _client.Get(action: "Info", type: User.self, parameters: CollectParameters())
    }
}
