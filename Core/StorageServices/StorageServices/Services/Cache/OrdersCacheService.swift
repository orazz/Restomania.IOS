//
//  OrdersCacheService.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 23.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreTools
import CoreDomains
import CoreApiServices

public protocol OrdersCacheServiceDelegate {
    func update(_: Long, update: DishOrder)
    func update(range: [DishOrder])
}
public class OrdersCacheService {

    private let tag = String.tag(OrdersCacheService.self)
    private let guid = Guid.new

    private let api: UserOrdersApiService
    private let apiQueue: AsyncQueue
    private let eventsAdapter: EventsAdapter<OrdersCacheServiceDelegate>
    private let cacheAdapter: CacheAdapter<DishOrder>
    private let keys: ApiKeyService

    public init(_ api: UserOrdersApiService, _ keys: ApiKeyService) {

        self.api = api
        self.keys = keys
        apiQueue = AsyncQueue.createForApi(for: tag)
        eventsAdapter = EventsAdapter<OrdersCacheServiceDelegate>(tag: tag)
        cacheAdapter = CacheAdapter(tag: tag,
                               filename: "dish-orders.json",
                               livetime: 3 * 24 * 60 * 60,
                               freshtime: 20 * 60,
                               needSaveFreshDate: true)

        keys.subscribe(guid: guid, handler: self, tag: tag)
    }
    public func load() {
        cacheAdapter.loadCached()
    }
    public func clear() {
        cacheAdapter.clear()
    }

    //Local
    public var cache: CacheAdapterExtender<DishOrder> {
        return cacheAdapter.extender
    }

    //Remote
    public func all(args: GetArgs? = nil) -> RequestResult<[DishOrder]> {
        return RequestResult<[DishOrder]> { handler in

            let request = self.api.all(args: args)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let orders = response.data!

                    self.cacheAdapter.addOrUpdate(orders)
                    self.cacheAdapter.clearOldCached()

                    self.eventsAdapter.invoke({ $0.update(range: orders) })
                }

                handler(response)
            }
        }
    }
    public func find(_ orderId: Long) -> RequestResult<DishOrder> {
        return RequestResult<DishOrder> { handler in

            let request = self.api.find(orderId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(order)
                    self.eventsAdapter.invoke({ $0.update(order.ID, update: order) })
                }

                handler(response)
            }
        }
    }

    public func add(_ order: AddedOrder) -> RequestResult<DishOrder> {
        return RequestResult<DishOrder> { handler in

            let request = self.api.add(order)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(response.data!)
                    self.eventsAdapter.invoke({ $0.update(order.ID, update: order) })
                }

                handler(response)
            }
        }
    }
    public func cancel(_ orderId: Long) -> RequestResult<DishOrder> {
        return RequestResult<DishOrder> { handler in

            let request = self.api.cancel(orderId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(order)
                    self.eventsAdapter.invoke({ $0.update(order.ID, update: order) })
                }

                handler(response)
            }
        }
    }
}
extension OrdersCacheService : IEventsEmitter {
    public typealias THandler = OrdersCacheServiceDelegate

    public func subscribe(guid: String, handler: OrdersCacheServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
extension OrdersCacheService: ApiKeyServiceDelegate {
    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {
        if (role == .user) {
            clear()
        }
    }
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {
        if (role == .user) {
            clear()
        }
    }
}
extension OrdersCacheServiceDelegate {
    public func update(_ orderId: Long, update: DishOrder) {}
    public func update(range: [DishOrder]) {}
}
