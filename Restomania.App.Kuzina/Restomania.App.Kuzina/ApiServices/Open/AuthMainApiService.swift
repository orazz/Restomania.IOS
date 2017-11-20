//
//  AccountsOpenApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class AuthMainApiService: BaseApiService {

    public init() {
        super.init(area: "Auth", tag: String.tag(AuthMainApiService.self))
    }

    public func refresh(keys: ApiKeys) -> RequestResult<ApiKeys> {
        let parameters = CollectParameters([
            "keys": keys
            ])

        return _client.Get(action: "Refresh", type: ApiKeys.self, parameters: parameters)
    }
    public func isAuth(keys: ApiKeys, role: ApiRole) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "keys": keys,
            "role": role.rawValue
        ])

        return _client.GetBool(action: "IsAuth", parameters: parameters)
    }
    public func Login(email: String, password: String, role: ApiRole) -> RequestResult<ApiKeys> {
        let parameters = CollectParameters([
            "email": email,
            "password": password,
            "role": role.rawValue
        ])

        return _client.Get(action: "Login", type: ApiKeys.self, parameters: parameters)
    }
    public func SignUp(email: String, password: String, role: ApiRole) -> RequestResult<ApiKeys> {
        let parameters = CollectParameters([
            "email": email,
            "password": password,
            "role": role.rawValue
        ])

        return _client.Post(action: "SignUp", type: ApiKeys.self, parameters: parameters)
    }

    public func ChangePass(keys: ApiKeys, password: String, oldPassword: String) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "keys": keys,
            "password": password,
            "oldPassword": oldPassword
        ])

        return _client.PutBool(action: "ChangePass", parameters: parameters)
    }
    public func RecoverPassword(email: String, role: ApiRole) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "email": email,
            "role": role.rawValue
        ])

        return _client.PutBool(action: "RecoverPassword", parameters: parameters)
    }
}
