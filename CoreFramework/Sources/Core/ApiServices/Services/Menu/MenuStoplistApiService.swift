//
//  MenuStoplistApiService.swift
//  CoreFramework
//
//  Created by Алексей on 23.04.2018.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class MenuStoplistApiService: BaseApiService {

    public init(_ configs: ConfigsContainer) {
        super.init(area: "Menu/Stoplist", type: MenuStoplistApiService.self, configs: configs)
    }

    public func find(placeId: Long) -> RequestResult<Stoplist> {

        let parameters = CollectParameters([
            "placeId": placeId
            ])

        return client.Get(action: "Find", type: Stoplist.self, parameters: parameters)
    }
}

