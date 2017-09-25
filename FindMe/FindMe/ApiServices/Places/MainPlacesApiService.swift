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

public class MainPlacesApiService: BaseApiService {

    public init() {
        super.init(area: "Places")
    }

    //MARK: Methods
    public func All(args: SelectParameters) -> RequestResult<[Place]> {

        let parameters = CollectParameters([
                "time": args.time?.prepareForJson()
            ])

        return _client.GetRange(action: "All", type: Place.self)
    }
    public func Find(placeId: Long) -> RequestResult<Place> {

        let parameters = CollectParameters([
            "placeID": placeId
            ])

        return _client.GetRange(action: "Find", type: Place.self)
    }
    public func SearchCards(args: SelectParameters) -> RequestResult<[SearchPlaceCard]> {

        let parameters = CollectParameters([
            "time": args.time?.prepareForJson()
            ])

        return _client.Get(action: "SearchCards", type: SearchPlaceCard.self)
    }

}
