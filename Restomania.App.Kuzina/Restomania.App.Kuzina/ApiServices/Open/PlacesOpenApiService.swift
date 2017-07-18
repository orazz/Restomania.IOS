//
//  PlacesOpenApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class PlacesOpenApiService: BaseApiService {
    public init() {
        super.init(area: "Open/Places", tag: "PlacesOpenApiService")
    }

    public func All(args:GetArgs? = nil) -> Task<RequestResult<[Place]>> {
        let parameters: [String:Any?] = [
            "time": args?.time
        ]

        return _client.GetRange(action: "All", type: Place.self, parameters: parameters as? Parameters)
    }
    public func Find(placeID: Int64) -> Task<RequestResult<Place>> {
        let parameters: [String:Any] = [
            "placeID": placeID
        ]

        return _client.Get(action: "Find", type: Place.self, parameters: parameters as? Parameters)
    }
    public func FindRange(range: [Int64]) -> Task<RequestResult<[Place]>> {
        let parameters: [String:Any] = [
            "placeIDs": range
        ]

        return _client.GetRange(action: "Range", type: Place.self, parameters: parameters as? Parameters)
    }

}
