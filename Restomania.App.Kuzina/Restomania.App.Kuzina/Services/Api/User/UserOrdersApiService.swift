//
//  UserOrdersApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class UserOrdersApiService: BaseAuthApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "User/DishOrders", tag: String.tag(UserOrdersApiService.self), configs: configs, keys: keys)
    }

    public func all(args: GetArgs? = nil) -> RequestResult<[DishOrder]> {

        let parameters = CollectParameters(for: .user, [
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: DishOrder.self, parameters: parameters)
    }

    public func find(orderID: Int64) -> RequestResult<DishOrder> {

        let parameters = CollectParameters(for: .user, [
                "orderId": orderID
            ])

        return _client.Get(action: "Find", type: DishOrder.self, parameters: parameters)
    }
    public func add(order: AddedOrder) -> RequestResult<DishOrder> {
        let parameters = CollectParameters(for: .user, [
                "container": order
            ])

        return _client.Post(action: "Add", type: DishOrder.self, parameters: parameters)
    }
    public func cancel(orderID: Int64) -> RequestResult<DishOrder> {
        let parameters = CollectParameters(for: .user, [
                "orderId": orderID
            ])

        return _client.Put(action: "Cancel", type: DishOrder.self, parameters: parameters)
    }
}
