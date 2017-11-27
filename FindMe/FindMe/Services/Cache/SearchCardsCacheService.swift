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
    private let client: PlacesMainApiService
    private let properties: PropertiesStorage<PropertiesKey>
    private let adapter: CacheRangeAdapter<SearchPlaceCard>

    //MARK: Cached processing
    public let cache: CachedProcessAdapter<SearchPlaceCard>


    public init(configs: ConfigsStorage, properties: PropertiesStorage<PropertiesKey>) {

        self.properties = properties
        self.client = PlacesMainApiService(configs)
        self.adapter = CacheRangeAdapter<SearchPlaceCard>(tag: tag, filename: "places-search-cards.json", livetime: 24 * 60 * 60)

        self.cache = CachedProcessAdapter<SearchPlaceCard>(for: self.adapter)

        Log.Debug(tag, "Complete load service.")
    }


    //MARK: Remote
    public func allRemote(with parameters: SelectParameters) -> Task<[SearchPlaceCard]?> {

        return Task { (handler: @escaping (([SearchPlaceCard]?) -> Void)) in

            Log.Debug(self.tag, "Request all places' cards.")

            let request = self.client.searchCards(with: parameters)
            request.async(.custom(self.adapter.blockQueue), completion: { response in

                if response.isFail {
                    handler(nil)
                    Log.Warning(self.tag, "Problem with request all search cards.")

                }
                else if let update = response.data {

                    self.adapter.addOrUpdate(update)
                    self.adapter.clearOldCached()
                    handler(self.adapter.localData)
                    Log.Debug(self.tag, "Complete request all.")
                }
            })
        }
    }
//    public func refresh() {
//
//        if (adapter.isEmpty) {
//            return
//        }
//
//        adapter.blockQueue.async {
//
//            Log.Debug(self.tag, "Start refresh data.")
//
////            let time = self._properties.getDate(.lastUpdateSearchCards)
//            let request = self.client.SearchCards(with: SelectParameters())
////            let request = self._client.SearchCards(args: SelectParameters(time: time.unwrapped))
//            request.async(.custom(self.adapter.blockQueue), completion: { response in
//
//                guard response.isSuccess,
//                    let update = response.data else {
//
//                    Log.Warning(self.tag, "Problem with refresh data.")
//                    return
//                }
//
//                self.adapter.addOrUpdate(update)
//                self.properties.set(.lastUpdateSearchCards, value: Date())
//                Log.Info(self.tag, "Complete refresh data.")
//            })
//        }
//    }
}
