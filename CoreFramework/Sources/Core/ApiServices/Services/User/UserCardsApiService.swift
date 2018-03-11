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

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/Cards", type: UserCardsApiService.self, configs: configs, keys: keys)
    }

    // MARK: Methods
    public func all(args: SelectArguments? = nil) -> RequestResult<[PaymentCard]> {
        let parameters = CollectParameters()

        return client.GetRange(action: "All", type: PaymentCard.self, parameters: parameters)
    }
    public func find(by cardId: Long) -> RequestResult<PaymentCard> {
        let parameters = CollectParameters([
                "cardId": cardId
            ])

        return client.Get(action: "Find", type: PaymentCard.self, parameters: parameters)
    }

    public func add(for paymentSystem: PaymentSystem? = nil) -> RequestResult<AddingCard> {
        let parameters = CollectParameters([
                "currency": configs.currency.rawValue,
                "client": paymentSystem ?? configs.paymentSystem.rawValue,
                "mobile": true
            ])

        return client.Post(action: "Add", type: AddingCard.self, parameters: parameters)
    }
    public func remove(cardId: Long) -> RequestResult<Bool> {
        let parameters = CollectParameters([
                "cardId": cardId
            ])

        return client.DeleteBool(action: "Remove", parameters: parameters)
    }
}
