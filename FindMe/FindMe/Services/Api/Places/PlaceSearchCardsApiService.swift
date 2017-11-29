//
//  PlaceSearchCardsApiService.swift
//  FindMe
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class PlaceSearchCardsApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places/SearchCards", configs: configs, tag: String.tag(PlaceSearchCardsApiService.self))
    }


    public func all(with arguments: SelectParameters, towns: [Long]? = nil) -> RequestResult<[SearchPlaceCard]> {
        let parameters = CollectParameters([
            "arguments": arguments,
            "towns": towns
            ])

        return client.GetRange(action: "All", type: SearchPlaceCard.self, parameters: parameters)
    }
}
