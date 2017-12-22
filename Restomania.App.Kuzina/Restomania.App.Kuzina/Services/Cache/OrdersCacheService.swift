//
//  OrdersCacheService.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 23.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class OrdersCacheService {

    private let tag = String.tag(OrdersCacheService.self)
    private let guid = Guid.new

    private let api = ApiServices.Users.orders
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<DishOrder>
    private let keys = ToolsServices.shared.keys

    public init() {
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter(tag: tag,
                               filename: "dish-orders.json",
                               livetime: 20 * 60 * 60,
                               freshtime: 60 * 60,
                               needSaveFreshDate: true)
        keys.subscribe(guid: guid, handler: self, tag: tag)
    }
    public func load() {
        adapter.loadCached()
    }
    public func clear() {
        adapter.clear()
    }

    //Local
    public var cache: CacheAdapterExtender<DishOrder> {
        return adapter.extender
    }

    //Remote
    public func all(args: GetArgs? = nil) -> RequestResult<[DishOrder]> {
        return RequestResult<[DishOrder]> { handler in

            let request = self.api.all(args: args)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                    self.adapter.clearOldCached()
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
                    self.adapter.addOrUpdate(response.data!)
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
                    self.adapter.addOrUpdate(response.data!)
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
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            }
        }
    }
}

extension OrdersCacheService: KeysStorageDelegate {
    public func set(keys: ApiKeys, for role: ApiRole) {
        if (role == .user) {
            clear()
        }
    }
    public func remove(for role: ApiRole) {
        if (role == .user) {
            clear()
        }
    }
}
