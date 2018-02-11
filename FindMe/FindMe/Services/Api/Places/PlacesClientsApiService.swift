//
//  PlacesClientsApiService.swift
//  FindMe
//
//  Created by Алексей on 31.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class PlacesClientsApiService: BaseApiService {

    public init(_ configs: ConfigsStorage) {
        super.init(area: "Places/Clients", configs: configs, tag: String.tag(PlacesClientsApiService.self))
    }

    //MARK: Methods
    public func all(in placeId: Long) -> RequestResult<[PlaceClient]> {

        let parameters = CollectParameters([
            "placeId": placeId
            ])

        return client.GetRange(action: "All", type: PlaceClient.self, parameters: parameters)
    }
}
