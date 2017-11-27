//
//  MainPlacesApiService.swift
//  FindMe
//
//  Created by Алексей on 26.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class PlacesMainApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places", configs: configs, tag: String.tag(PlacesMainApiService.self))
    }

    //MARK: Methods
    public func All(with arguments: SelectParameters, towns: [Long]? = nil) -> RequestResult<[DisplayPlaceInfo]> {

        let parameters = CollectParameters([
                "arguments": arguments,
                "towns": towns
            ])

        return _client.GetRange(action: "All", type: DisplayPlaceInfo.self, parameters: parameters)
    }
    public func Find(placeId: Long) -> RequestResult<DisplayPlaceInfo> {

        let parameters = CollectParameters([
                "placeId": placeId
            ])

        return _client.Get(action: "Find", type: DisplayPlaceInfo.self, parameters: parameters)
    }
    public func range(ids: [Long]) -> RequestResult<[DisplayPlaceInfo]> {

        let parameters = CollectParameters([
            "placeIds": ids
            ])

        return _client.GetRange(action: "Range", type: DisplayPlaceInfo.self, parameters: parameters)
    }
    public func SearchCards(with arguments: SelectParameters, towns: [Long]? = nil) -> RequestResult<[SearchPlaceCard]> {

        let parameters = CollectParameters([
                "arguments": arguments,
                "towns": towns
            ])

        return _client.GetRange(action: "SearchCards", type: SearchPlaceCard.self, parameters: parameters)
    }
}
