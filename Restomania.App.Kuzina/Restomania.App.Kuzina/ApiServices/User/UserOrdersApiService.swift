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

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/DishOrders", tag: "UserOrdersApiService")
    }

    public func all(args: GetArgs? = nil) -> RequestResult<[DishOrder]> {

        let parameters = CollectParameters([
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: DishOrder.self, parameters: parameters)
    }

    public func find(orderID: Int64) -> RequestResult<DishOrder> {

        let parameters = CollectParameters([
                "elementID": orderID
            ])

        return _client.Get(action: "Find", type: DishOrder.self, parameters: parameters)
    }
    public func add(order: AddedOrder) -> RequestResult<DishOrder> {
        let parameters = CollectParameters([
                "data": order
            ])

        return _client.Post(action: "Add", type: DishOrder.self, parameters: parameters)
    }
    public func cancel(orderID: Int64) -> RequestResult<DishOrder> {
        let parameters = CollectParameters([
                "orderID": orderID
            ])

        return _client.Put(action: "Cancel", type: DishOrder.self, parameters: parameters)
    }
}
