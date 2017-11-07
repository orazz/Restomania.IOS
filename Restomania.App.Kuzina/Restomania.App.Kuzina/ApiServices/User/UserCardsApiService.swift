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
        super.init(storage: storage, rights: .User, area: "User/Cards", tag: String.tag(UserCardsApiService.self))
    }

    // MARK: Methods
    public func alll(args: GetArgs? = nil) -> RequestResult<[PaymentCard]> {
        let parameters = CollectParameters([
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: PaymentCard.self, parameters: parameters)
    }

    public func add(currency: CurrencyType) -> RequestResult<AddingCard> {
        let parameters = CollectParameters([
                "currency": currency.rawValue,
                "mobile": true
            ])

        return _client.Post(action: "Add", type: AddingCard.self, parameters: parameters)
    }
    public func remove(cardID: Int64) -> RequestResult<Bool> {
        let parameters = CollectParameters([
                "elementID": cardID
            ])

        return _client.DeleteBool(action: "Remove", parameters: parameters)
    }
}
