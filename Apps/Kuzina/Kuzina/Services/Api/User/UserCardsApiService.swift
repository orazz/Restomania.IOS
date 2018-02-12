//
//  CardsUserApiService.swift
//  Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UserCardsApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "User/Cards", type: UserCardsApiService.self, configs: configs, keys: keys)
    }

    // MARK: Methods
    public func all(args: GetArgs? = nil) -> RequestResult<[PaymentCard]> {
        let parameters = CollectParameters(for: .user)

        return client.GetRange(action: "All", type: PaymentCard.self, parameters: parameters)
    }
    public func find(by cardId: Long) -> RequestResult<PaymentCard> {
        let parameters = CollectParameters(for: .user, [
                "cardId": cardId
            ])

        return client.Get(action: "Find", type: PaymentCard.self, parameters: parameters)
    }

    public func add(currency: CurrencyType) -> RequestResult<AddingCard> {
        let parameters = CollectParameters(for: .user, [
                "currency": currency.rawValue,
                "mobile": true
            ])

        return client.Post(action: "Add", type: AddingCard.self, parameters: parameters)
    }
    public func remove(cardId: Long) -> RequestResult<Bool> {
        let parameters = CollectParameters(for: .user, [
                "cardId": cardId
            ])

        return client.DeleteBool(action: "Remove", parameters: parameters)
    }
}
