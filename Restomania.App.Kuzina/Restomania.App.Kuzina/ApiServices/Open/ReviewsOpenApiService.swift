//
//  ReviewsOpenApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class ReviewsOpenApiService: BaseApiService {
    public init() {
        super.init(area: "Open/Reviews", tag: "ReviewsOpenApiService")
    }

    public func ByPlace(placeID: Int64, args: GetArgs? = nil) -> Task<RequestResult<[Review]>> {
        let parameters = CollectParameters([
            "placeID": placeID,
            "time": args?.time
        ])

        return _client.GetRange(action: "ByPlace", type: Review.self, parameters: parameters )
    }
    public func ByUser(userID: Int64, args: GetArgs? = nil) -> Task<RequestResult<[Review]>> {
        let parameters = CollectParameters([
            "userID": userID,
            "time": args?.time
        ])

        return _client.GetRange(action: "ByUser", type: Review.self, parameters: parameters)
    }
}
