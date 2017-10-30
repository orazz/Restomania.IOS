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
        super.init(area: "Places",configs: configs, tag: String.tag(PlacesMainApiService.self))
        
    }

    //MARK: Methods
    public func All(args: SelectParameters) -> RequestResult<[Place]> {

        let parameters = CollectParameters([
                "time": args.time?.prepareForJson()
            ])

        return _client.GetRange(action: "All", type: Place.self, parameters: parameters)
    }
    public func Find(placeId: Long) -> RequestResult<Place> {

        let parameters = CollectParameters([
                "placeID": placeId
            ])

        return _client.Get(action: "Find", type: Place.self, parameters: parameters)
    }
    public func range(ids: [Long]) -> RequestResult<[Place]> {

        let parameters = CollectParameters([
            "placeIds": ids
            ])

        return _client.GetRange(action: "Range", type: Place.self, parameters: parameters)
    }
    public func SearchCards(args: SelectParameters) -> RequestResult<[SearchPlaceCard]> {

        let parameters = CollectParameters([
                "time": args.time?.prepareForJson()
            ])

        return _client.GetRange(action: "SearchCards", type: SearchPlaceCard.self, parameters: parameters)
    }

}
