//
//  OpenMenuSummariesApiService.swift
//  Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains
import CoreTools

public class MenuSummariesApiService: BaseApiService {

    public init(_ configs: ConfigsContainer) {
        super.init(area: "Menu/Summaries", type: MenuSummariesApiService.self, configs: configs)
    }

    public func find(placeID: Long) -> RequestResult<MenuSummary> {

        let parameters = CollectParameters([
                "placeId": placeID
            ])

        return client.Get(action: "Find", type: MenuSummary.self, parameters: parameters)
    }
    public func range(placeIDs: [Long]) -> RequestResult<[MenuSummary]> {

        let parameters = CollectParameters([
                "placeIds": placeIDs
            ])

        return client.GetRange(action: "Range", type: MenuSummary.self, parameters: parameters)
    }
}