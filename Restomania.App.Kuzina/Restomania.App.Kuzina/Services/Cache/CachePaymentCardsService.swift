//
//  CachePaymentCardsService.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class CachePaymentCardsService {

    private let apiClient: UserCardsApiService
    private var cached: [PaymentCard]?

    public init(keys: IKeysStorage) {
        apiClient = UserCardsApiService(storage: keys)
    }

    public func all() -> Task<[PaymentCard]?> {

        return Task<[PaymentCard]?>(action: { handler in

            if let cached = self.cached {
                handler(cached)
                return
            }

            let request = self.apiClient.all()
            request.async(.background, completion: { response in

                if (response.isSuccess) {
                    self.cached = response.data!
                }

                handler(self.cached)
            })
        })
    }
    public func find(_ cardId: Long) -> Task<PaymentCard?> {
        return Task<PaymentCard?>(action: { handler in

            if let cached = self.cached?.find({ $0.ID == cardId }) {
                handler(cached)
                return
            }

            let request = self.apiClient.find(by: cardId)
            request.async(.background, completion: { response in

                if let card = response.data {
                    self.cached?.append(card)
                }

                handler(response.data)
            })
        })
    }
}
