//
//  PlaceSummariesApiService.swift
//  Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import CoreDomains
import CoreTools

public class PlaceSummariesApiService: BaseApiService {

    public init(_ configs: ConfigsContainer) {
        super.init(area: "Place/Summaries", type: PlaceSummariesApiService.self, configs: configs)
    }

    public func all(arguments: SelectArguments? = nil) -> RequestResult<[PlaceSummary]> {
        let parameters = CollectParameters([
                "arguments": arguments
            ])

        return client.GetRange(action: "Index", type: PlaceSummary.self, parameters: parameters)
    }
    public func chain(_ chainId: Long, includeHidden: Bool = false) -> RequestResult<[PlaceSummary]> {
        let parameters = CollectParameters([
                "chainId": chainId,
                "includeHidden": includeHidden
            ])

        return client.GetRange(action: "Chain", type: PlaceSummary.self, parameters: parameters)
    }
    public func range(placeIDs: [Long]) -> RequestResult<[PlaceSummary]> {
        let parameters = CollectParameters([
                "placeIDs": placeIDs
            ])

        return client.GetRange(action: "Range", type: PlaceSummary.self, parameters: parameters)
    }

    public func find(placeId: Long) -> RequestResult<PlaceSummary> {
        let parameters = CollectParameters([
                "placeId": placeId
            ])

        return client.Get(action: "Find", type: PlaceSummary.self, parameters: parameters)
    }
}
