//
//  OrdersCacheService.swift
//  CoreFramework
//
//  Created by Алексей on 23.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol OrdersCacheServiceDelegate {
    func update(_: Long, update: DishOrder)
    func update(range: [DishOrder])
}
public class OrdersCacheService {

    private let tag = String.tag(OrdersCacheService.self)
    private let guid = Guid.new

    private let searchApi: OrdersApiService
    private let changeApi: OrdersChangeApiService
    private let apiQueue: AsyncQueue
    private let eventsAdapter: EventsAdapter<OrdersCacheServiceDelegate>
    private let cacheAdapter: CacheAdapter<DishOrder>
    private let keys: ApiKeyService

    public init(_ searchApi: OrdersApiService, _ changeApi: OrdersChangeApiService,  _ keys: ApiKeyService) {

        self.searchApi = searchApi
        self.changeApi = changeApi
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
    public func all(chainId: Long? = nil,
                    placeId: Long? = nil,
                   statuses: [DishOrderStatus]? = nil,
               updatedAfter: Date? = nil,
                      count: Bool? = nil,
                  arguments: SelectArguments? = nil) -> RequestResult<GetResult<DishOrder>> {

        return RequestResult<GetResult<DishOrder>> { handler in

            let request = self.searchApi.all(chainId: chainId, placeId: placeId, statuses: statuses, updatedAfter: updatedAfter, count: count, arguments: arguments)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let orders = response.data!.entities

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

            let request = self.searchApi.find(orderId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(order)
                    self.eventsAdapter.invoke({ $0.update(order.id, update: order) })
                }

                handler(response)
            }
        }
    }

    public func add(_ order: AddedOrder) -> RequestResult<DishOrder> {
        return RequestResult<DishOrder> { handler in

            let request = self.changeApi.add(order)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(response.data!)
                    self.eventsAdapter.invoke({ $0.update(order.id, update: order) })
                }

                handler(response)
            }
        }
    }
    public func cancel(_ orderId: Long) -> RequestResult<DishOrder> {
        return RequestResult<DishOrder> { handler in

            let request = self.changeApi.cancel(orderId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    let order = response.data!

                    self.cacheAdapter.addOrUpdate(order)
                    self.eventsAdapter.invoke({ $0.update(order.id, update: order) })
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
        let needRemove = cache.where({ $0.userId == keys.accountId || $0.placeId == keys.accountId })
        cacheAdapter.remove(needRemove)
    }
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {
        clear()
    }
}
extension OrdersCacheServiceDelegate {
    public func update(_ orderId: Long, update: DishOrder) {}
    public func update(range: [DishOrder]) {}
}
