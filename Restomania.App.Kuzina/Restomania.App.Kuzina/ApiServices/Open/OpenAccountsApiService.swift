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

public class OpenAccountsApiService: BaseApiService {

    public init() {
        super.init(area: "Open/Accounts", tag: "OpenAccountsApiService")
    }

    public func IsAuth(keys: AccessKeys, rights: AccessRights) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "keys": keys,
            "rights": rights.rawValue
        ])

        return _client.GetBool(action: "IsAuth", parameters: parameters)
    }
    public func Login(email: String, password: String, rights: AccessRights) -> RequestResult<AccessKeys> {
        let parameters = CollectParameters([
            "email": email,
            "pass": password,
            "rights": rights.rawValue
        ])

        return _client.Get(action: "Login", type: AccessKeys.self, parameters: parameters)
    }
    public func SignUp(email: String, password: String, rights: AccessRights) -> RequestResult<AccessKeys> {
        let parameters = CollectParameters([
            "email": email,
            "pass": password,
            "rights": rights.rawValue
        ])

        return _client.Post(action: "SignUp", type: AccessKeys.self, parameters: parameters)
    }

    public func ChangePass(keys: AccessKeys, rights: AccessRights, pass: String, oldPass: String) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "keys": keys,
            "rights": rights.rawValue,
            "pass": pass,
            "oldPass": oldPass
        ])

        return _client.PutBool(action: "ChangePass", parameters: parameters)
    }
    public func RecoverPassword(email: String, rights: AccessRights) -> RequestResult<Bool> {
        let parameters = CollectParameters([
            "email": email,
            "rights": rights.rawValue
        ])

        return _client.PutBool(action: "RecoverPassword", parameters: parameters)
    }

    public func GetSocnetKey(keys: AccessKeys, method: MethodConnection) -> RequestResult<Int64> {
        let parameters = CollectParameters([
            "keys": keys,
            "method": method
        ])

        return _client.GetLong(action: "GetSocnetKey", parameters: parameters)
    }
}
