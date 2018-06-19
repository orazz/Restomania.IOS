//
//  OrdersApiService.swift
//  CoreFramework
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class OrdersApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "Orders/Main", type: OrdersApiService.self, configs: configs, keys: keys)
    }

    public func all(chainId: Long? = nil,
                    placeId: Long? = nil,
                   statuses: [DishOrderStatus]? = nil,
               updatedAfter: Date? = nil,
                      count: Bool? = nil,
                  arguments: SelectArguments? = nil) -> RequestResult<GetResult<DishOrder>> {

        let parameters = CollectParameters([
                "chainId": chainId,
                "placeId": placeId,
                "statuses": statuses,
                "updatedAfter": updatedAfter,
                "count": count,
                "arguments": arguments,
            ])

        return client.Get(action: "Index", type: GetResult.self, parameters: parameters)
    }

    public func find(_ orderId: Long) -> RequestResult<DishOrder> {

        let parameters = CollectParameters([
                "orderId": orderId
            ])

        return client.Get(action: "Find", type: DishOrder.self, parameters: parameters)
    }
}
