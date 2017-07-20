//
//  OpenPlaceSummariesApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class OpenPlaceSummariesApiService: BaseApiService {

    public init() {
        super.init(area: "Open/PlaceSummaries", tag: "OpenPlaceSummariesApiService")
    }

    public func Range(placeIDs: [Long]) -> RequestResult<[PlaceSummary]> {
        let parameters = CollectParameters([
            "placeIDs": placeIDs
            ])

        return _client.GetRange(action: "Range", type: PlaceSummary.self, parameters: parameters)
    }
}
