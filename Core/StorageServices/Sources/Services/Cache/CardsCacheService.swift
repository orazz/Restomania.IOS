//
//  CardsCacheService.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 09.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreTools
import CoreDomains
import CoreApiServices

public class CardsCacheService {

    private let tag = String.tag(CardsCacheService.self)
    private let guid = Guid.new

    private let api: UserCardsApiService
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<PaymentCard>
    private let keys: ApiKeyService

    public init(_ api: UserCardsApiService, _ keys: ApiKeyService) {

        self.api = api
        self.keys = keys
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter(tag: tag,
                               filename: "payment-cards.json",
                               livetime: 5 * 60 * 60,
                              freshtime: 5 * 60)

        keys.subscribe(guid: guid, handler: self, tag: tag)
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
    public func remove(_ cardId: Long) -> RequestResult<Bool> {
        return RequestResult<Bool> { handler in

            let request = self.api.remove(cardId: cardId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.remove(cardId)
                }

                handler(response)
            }
        }
    }
}

extension CardsCacheService: ApiKeyServiceDelegate {
    public func apiKeyService(update keys: ApiKeys, for role: ApiRole) {

        if (role == .user) {
            adapter.clear()
        }
    }
    public func apiKeyService(logout role: ApiRole) {

        if (role == .user) {
            adapter.clear()
        }
    }
}
