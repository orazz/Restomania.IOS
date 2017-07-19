//
//  UserLoyaltyApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class UserLoyaltyApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/Loyalty", tag: "UserLoyaltyApiService")
    }

    public func Account(placeID: Int64) -> RequestResult<LoyaltyAccount> {
        let parameters = CollectParameters([
                "placeID": placeID
            ])

        return _client.Get(action: "Account", type: LoyaltyAccount.self, parameters: parameters)
    }
    public func Select(placeID: Int64, loyaltySystemID: Int64) -> RequestResult<BaseLoyaltySystem> {
        let parameters = CollectParameters([
                "placeID": placeID,
                "loyaltySystemID": loyaltySystemID
            ])

        return _client.Put(action: "Select", type: BaseLoyaltySystem.self, parameters: parameters)
    }
}
