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

    private let _tag: String
    private let _client: PlacesMainApiService
    private let _adapter: CacheRangeAdapter<SearchPlaceCard>
    private let _properties: PropertiesStorage<PropertiesKey>


    
    public init(configs: ConfigsStorage, properties: PropertiesStorage<PropertiesKey>) {

        _tag = String.tag(SearchPlaceCardsCacheService.self)
        _client = PlacesMainApiService(configs)
        _adapter = CacheRangeAdapter<SearchPlaceCard>(tag: _tag, filename: "places-search-cards.json", livetime: 24 * 60 * 60)
        _properties = properties

        Log.Debug(_tag, "Complete load service.")

        refresh()
    }



    //MARK: Local
    public var allLocal: [SearchPlaceCard] {
        return _adapter.localData
    }
    public func checkLocal(_ range: [Long]) -> CacheSearchResult<Long>{
        return _adapter.checkCache(range)
    }
    public func findInLocal(_ placeId: Long) -> SearchPlaceCard? {
        return _adapter.find(placeId)
    }
    public func rangeInLocal(_ range: [Long]) -> [SearchPlaceCard] {
        return _adapter.range(range)
    }


    //MARK: Remote
    
    public func all() -> Task<[SearchPlaceCard]?> {

        return Task { (handler: @escaping (([SearchPlaceCard]?) -> Void)) in

            Log.Debug(self._tag, "Request all places' cards.")

            let request = self._client.SearchCards(args: SelectParameters(time: nil))
            request.async(.custom(self._adapter.blockQueue), completion: { response in

                guard response.isSuccess,
                    let update = response.data else {

                        handler(nil)
                        Log.Warning(self._tag, "Problem with request all search cards.")
                        return
                }

                self._adapter.addOrUpdate(with: update)
                handler(self._adapter.localData)
                Log.Debug(self._tag, "Complete request all.")
            })
        }
    }
    public func refresh() {

        if (_adapter.isEmpty) {
            return
        }

        _adapter.blockQueue.async {

            Log.Debug(self._tag, "Start refresh data.")

            let time = self._properties.getDate(.lastUpdateSearchCards)
            let request = self._client.SearchCards(args: SelectParameters(time: time.unwrapped))
            request.async(.custom(self._adapter.blockQueue), completion: { response in

                guard response.isSuccess,
                    let update = response.data else {

                    Log.Warning(self._tag, "Problem with refresh data.")
                    return
                }

                self._adapter.addOrUpdate(with: update)
                self._properties.set(.lastUpdateSearchCards, value: Date())
                Log.Info(self._tag, "Complete refresh data.")
            })
        }
    }
}
