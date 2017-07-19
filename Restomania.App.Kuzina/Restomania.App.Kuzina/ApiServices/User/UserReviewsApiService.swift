//
//  UserReviewsApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 19.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import IOSLibrary

public class UserReviewsApiService: BaseAuthApiService {

    public init(storage: IKeysStorage) {
        super.init(storage: storage, rights: .User, area: "User/Reviews", tag: "UserReviewsApiService")
    }

    public func All(args: GetArgs? = nil) -> RequestResult<[Review]> {
        let parameters = CollectParameters([
                "time": args?.time
            ])

        return _client.GetRange(action: "All", type: Review.self, parameters: parameters)
    }

    public func Add(review: Review) -> RequestResult<Review> {
        let parameters = CollectParameters([
                "data": review
            ])

        return _client.Post(action: "Add", type: Review.self, parameters: parameters)
    }
    public func Update(review: Review) -> RequestResult<Review> {
        let parameters = CollectParameters([
                "elementID": review.ID,
                "update": review
            ])

        return _client.Put(action: "Update", type: Review.self, parameters: parameters)
    }
    public func Remove(reviewID: Int64) -> RequestResult<Bool> {
        let parameters = CollectParameters([
                "reviewID": reviewID
            ])

        return _client.DeleteBool(action: "Remove", parameters: parameters)
    }
}
