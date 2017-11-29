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
    private let apiQueue: AsyncQueue

    //MARK: Cached processing
    public var cache: CacheAdapterExtender<SearchPlaceCard> {
        return adapter.extender
    }


    public init(properties: PropertiesStorage<PropertiesKey>) {

        self.properties = properties
        self.adapter = CacheAdapter<SearchPlaceCard>(tag: tag, filename: "places-search-cards.json", livetime: 24 * 60 * 60)
        self.apiQueue = AsyncQueue.custom(DispatchQueue.createApiQueue(for: tag))

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
            request.async(self.apiQueue, completion: { response in

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
    public func refresh() -> Task<Bool> {

        return Task<Bool>.init(action: { handler in

            Log.Debug(self.tag, "Try refresh data.")

            let places = self.cache.all.map{ $0.ID }
            if (places.isEmpty) {
                handler(true)
                return
            }

            let request = self.client.range(for: places)
            request.async(self.apiQueue, completion: { response in

                if (response.isFail) {
                    if (response.statusCode != .ConnectionError) {

                        Log.Warning(self.tag, "Problem with refresh data.")
                        handler(false)
                    }

                }
                else if let update = response.data {
                    
                    Log.Info(self.tag, "Complete refresh data.")

                    self.adapter.clear()
                    self.adapter.addOrUpdate(update)
                }

                handler(true)
            })

        })
    }
}
