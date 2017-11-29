//
//  SearchCardsCacheService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class SearchPlaceCardsCacheService {

    private let tag = String.tag(SearchPlaceCardsCacheService.self)
    private let client = ApiServices.Places.searchCards
    private let properties: PropertiesStorage<PropertiesKey>
    private let adapter: CacheAdapter<SearchPlaceCard>

    //MARK: Cached processing
    public var cache: CacheAdapterExtender<SearchPlaceCard> {
        return adapter.extender
    }


    public init(properties: PropertiesStorage<PropertiesKey>) {

        self.properties = properties
        self.adapter = CacheAdapter<SearchPlaceCard>(tag: tag, filename: "places-search-cards.json", livetime: 24 * 60 * 60)

        Log.Debug(tag, "Complete load service.")
    }

    public func load() {
        adapter.loadCached()
    }


    //MARK: Remote
    public func all(with parameters: SelectParameters) -> Task<ApiResponse<[SearchPlaceCard]>> {

        return Task { (handler: @escaping (ApiResponse<[SearchPlaceCard]>) -> Void) in

            Log.Debug(self.tag, "Request all places' cards.")

            let request = self.client.all(with: parameters)
            request.async(.custom(self.adapter.blockQueue), completion: { response in

                if response.isFail {
                    handler(response)
                    Log.Warning(self.tag, "Problem with request all search cards.")

                }
                else if let update = response.data {

                    self.adapter.addOrUpdate(update)
                    self.adapter.clearOldCached()
                    handler(response)
                    Log.Debug(self.tag, "Complete request all.")
                }
            })
        }
    }
    public func refresh() {

        Log.Debug(self.tag, "Start refresh data.")

        let request = self.all(with: SelectParameters(take: Int.max))
        request.async(.custom(self.adapter.blockQueue), completion: { response in

            if (response.isFail) {
                Log.Warning(self.tag, "Problem with refresh data.")
            }
            else if (response.isSuccess) {
                Log.Info(self.tag, "Complete refresh data.")
            }
        })
    }
}
