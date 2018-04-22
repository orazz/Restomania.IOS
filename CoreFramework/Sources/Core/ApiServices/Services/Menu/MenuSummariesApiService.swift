//
//  OpenMenuSummariesApiService.swift
//  CoreFramework
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class MenuSummariesApiService: BaseApiService {

    public init(_ configs: ConfigsContainer) {
        super.init(area: "Menu/Summaries", type: MenuSummariesApiService.self, configs: configs)
    }

    public func find(placeId: Long) -> RequestResult<MenuSummary> {

        let parameters = CollectParameters([
                "placeId": placeId
            ])

        return client.Get(action: "Find", type: MenuSummary.self, parameters: parameters)
    }
    public func range(placeIds: [Long]) -> RequestResult<[MenuSummary]> {

        let parameters = CollectParameters([
                "placeIds": placeIds
            ])

        return client.GetRange(action: "Range", type: MenuSummary.self, parameters: parameters)
    }
}
