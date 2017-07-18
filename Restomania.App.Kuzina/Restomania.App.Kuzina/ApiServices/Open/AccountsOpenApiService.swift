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

public class AccountsOpenApiService: BaseApiService {
    public init() {
        super.init(area: "Open/Accounts", tag: "AccountsOpenApiService")
    }

    public func IsAuth(keys: AccessKeys, rights: AccessRights) -> Task<RequestResult<Bool>> {
        let parameters: [String:Any] = [
            "keys": keys,
            "rights": rights
        ]

        return _client.GetBool(action: "IsAuth", parameters: parameters as? Parameters)
    }
    public func Login(email: String, password: String, rights: AccessRights) -> Task<RequestResult<AccessKeys>> {
        let parameters: [String:Any] = [
            "email": email,
            "pass": password,
            "rights": rights
        ]

        return _client.Get(action: "Login", type: AccessKeys.self, parameters: parameters as? Parameters)
    }
    public func SignUp(email: String, password: String, rights: AccessRights) -> Task<RequestResult<AccessKeys>> {
        let parameters: [String:Any] = [
            "email": email,
            "pass": password,
            "rights": rights
        ]

        return _client.Post(action: "SignUp", type: AccessKeys.self, parameters: parameters as? Parameters)
    }

    public func ChangePass(keys: AccessKeys, rights: AccessRights, pass: String, oldPass: String) -> Task<RequestResult<Bool>> {
        let parameters: [String:Any] = [
            "keys": keys,
            "rights": rights,
            "pass": pass,
            "oldPass": oldPass
        ]

        return _client.PutBool(action: "ChangePass", parameters: parameters as? Parameters)
    }
    public func RecoverPassword(email: String, rights: AccessRights) -> Task<RequestResult<Bool>> {
        let parameters: [String:Any] = [
            "email": email,
            "rights": rights
        ]

        return _client.PutBool(action: "RecoverPassword", parameters: parameters as? Parameters)
    }

    public func GetSocnetKey(keys: AccessKeys, method: MethodConnection) -> Task<RequestResult<Int64>> {
        let parameters: [String:Any] = [
            "keys": keys,
            "method": method
        ]

        return _client.GetLong(action: "GetSocnetKey", parameters: parameters as? Parameters)
    }
}
