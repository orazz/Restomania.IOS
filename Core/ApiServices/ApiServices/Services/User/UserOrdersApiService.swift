//
//  UserOrdersApiService.swift
//  Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains

public class UserOrdersApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "User/DishOrders", type: UserOrdersApiService.self, configs: configs, keys: keys)
    }

    public func all(args: GetArgs? = nil) -> RequestResult<[DishOrder]> {

        let parameters = CollectParameters(for: .user, [
                "time": args?.time
            ])

        return client.GetRange(action: "All", type: DishOrder.self, parameters: parameters)
    }

    public func find(_ orderId: Long) -> RequestResult<DishOrder> {

        let parameters = CollectParameters(for: .user, [
                "orderId": orderId
            ])

        return client.Get(action: "Find", type: DishOrder.self, parameters: parameters)
    }
    public func add(_ order: AddedOrder) -> RequestResult<DishOrder> {
        let parameters = CollectParameters(for: .user, [
                "container": order
            ])

        return client.Post(action: "Add", type: DishOrder.self, parameters: parameters)
    }
    public func cancel(_ orderId: Long) -> RequestResult<DishOrder> {
        let parameters = CollectParameters(for: .user, [
                "orderId": orderId
            ])

        return client.Put(action: "Cancel", type: DishOrder.self, parameters: parameters)
    }
}
