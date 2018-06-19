//
//  OrdersChangeApiService.swift/Users/aleksej/Documents/_dev/Restomania.IOS/CoreFramework/Sources/Core/ApiServices/Services/Orders/OrdersChangeApiService.swift
//  CoreFramework
//
//  Created by Алексей on 19.06.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class OrdersChangeApiService: BaseApiService {

    public init(_ configs: ConfigsContainer, _ keys: ApiKeyService) {
        super.init(area: "Orders/Change", type: OrdersChangeApiService.self, configs: configs, keys: keys)
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
