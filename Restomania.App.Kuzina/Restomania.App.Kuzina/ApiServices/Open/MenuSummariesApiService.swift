//
//  OpenMenuSummariesApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class MenuSummariesApiService: BaseApiService {

    public init() {
        super.init(area: "Menu/Summaries", tag: "MenuSummariesApiService")
    }

    public func find(placeID: Long) -> RequestResult<MenuSummary> {

        let parameters = CollectParameters([
                "placeId": placeID
            ])

        return _client.Get(action: "Find", type: MenuSummary.self, parameters: parameters)
    }
    public func range(placeIDs: [Long]) -> RequestResult<[MenuSummary]> {

        let parameters = CollectParameters([
                "placeIds": placeIDs
            ])

        return _client.GetRange(action: "Range", type: MenuSummary.self, parameters: parameters)
    }
}
