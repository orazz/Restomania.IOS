//
//  UserOrdersApiService.swift
//  CoreFramework
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class UserOrdersApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "User/DishOrders", type: UserOrdersApiService.self, configs: configs, keys: keys)
    }

    public func all(chainId: Long? = nil, placeId: Long? = nil, status: DishOrderStatus? = nil, updatedAfter: Date? = nil, arguments: SelectArguments? = nil) -> RequestResult<[DishOrder]> {

        let parameters = CollectParameters([
                "chainId": chainId,
                "placeId": placeId,
                "status": status,
                "updatedAfter": updatedAfter,
                "arguments": arguments,
            ])

        return client.GetRange(action: "Index", type: DishOrder.self, parameters: parameters)
    }

    public func find(_ orderId: Long) -> RequestResult<DishOrder> {

        let parameters = CollectParameters([
                "orderId": orderId
            ])

        return client.Get(action: "Find", type: DishOrder.self, parameters: parameters)
    }
    public func add(_ order: AddedOrder) -> RequestResult<DishOrder> {

        order.appKey = configs.appKey
        
        let parameters = CollectParameters([
                "container": order
            ])

        return client.Post(action: "Add", type: DishOrder.self, parameters: parameters)
    }
    public func cancel(_ orderId: Long) -> RequestResult<DishOrder> {
        let parameters = CollectParameters([
                "orderId": orderId
            ])

        return client.Put(action: "Cancel", type: DishOrder.self, parameters: parameters)
    }
}
