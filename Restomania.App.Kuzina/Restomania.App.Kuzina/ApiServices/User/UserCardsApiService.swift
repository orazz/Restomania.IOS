//
//  CardsUserApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class UserCardsApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/Cards", tag: "UserCardsApiService")
    }

    public func All(args: GetArgs? = nil) -> RequestResult<[PaymentCard]> {
        let parameters = CollectParameters([
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: PaymentCard.self, parameters: parameters)
    }

    public func Add(currency: CurrencyType) -> RequestResult<AddingCard> {
        let parameters = CollectParameters([
                "currency": currency.rawValue,
                "mobile": true
            ])

        return _client.Post(action: "Add", type: AddingCard.self, parameters: parameters)
    }
    public func Remove(cardID: Int64 ) -> RequestResult<Bool> {
        let parameters = CollectParameters([
                "elementID": cardID
            ])

        return _client.DeleteBool(action: "Remove", parameters: parameters)
    }
}
