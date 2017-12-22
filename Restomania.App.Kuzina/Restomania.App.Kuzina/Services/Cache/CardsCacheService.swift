//
//  CardsCacheService.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class CardsCacheService {

    private let tag = String.tag(CardsCacheService.self)

    private let api = ApiServices.Users.cards
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<PaymentCard>

    public init() {
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter(tag: tag, filename: "payment-cards.json", livetime: 5 * 60 * 60, freshtime: 5 * 60)
    }
    public func load() {
        adapter.loadCached()
        adapter.clearOldCached()
    }

    //Local
    public var cache: CacheAdapterExtender<PaymentCard> {
        return adapter.extender
    }

    public func all() -> RequestResult<[PaymentCard]> {

        return RequestResult<[PaymentCard]> { handler in

            let request = self.api.all()
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            }
        }
    }
    public func find(_ cardId: Long) -> RequestResult<PaymentCard> {

        return RequestResult<PaymentCard> { handler in

            let request = self.api.find(by: cardId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            }
        }
    }
}
