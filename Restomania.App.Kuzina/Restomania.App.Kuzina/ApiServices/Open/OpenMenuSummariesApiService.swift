//
//  OpenMenuSummariesApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class OpenMenuSummariesApiService: BaseApiService {

    public init() {
        super.init(area: "Open/MenuSummaries", tag: "OpenMenuSummariesApiService")
    }

    public func find(placeID: Long) -> RequestResult<MenuSummary> {

        let parameters = CollectParameters([
                "placeID": placeID
            ])

        return _client.Get(action: "Find", type: MenuSummary.self, parameters: parameters)
    }
    public func range(placeIDs: [Long]) -> RequestResult<[MenuSummary]> {

        let parameters = CollectParameters([
                "placeIDs": placeIDs
            ])

        return _client.GetRange(action: "Range", type: MenuSummary.self, parameters: parameters)
    }
}
