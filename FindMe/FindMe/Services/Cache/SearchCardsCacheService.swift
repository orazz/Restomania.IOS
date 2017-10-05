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


    //MARK: Remote

    public func refresh() {

        if (_adapter.isEmpty) {
            return
        }

        let task = Task { (handler: @escaping(_:Any?) -> Void) in

            Log.Debug(self._tag, "Start refresh data.")

            let time = self._properties.getDate(.lastUpdateSearchCards)
            let request = self._client.SearchCards(args: SelectParameters(time: time.unwrapped))
            let response = request.await()

            if (response.isFail) {

                handler(nil)
                Log.Warning(self._tag, "Problem with refresh data.")
                return
            }

            if let update = response.data {
                self._adapter.addOrUpdate(with: update)
                Log.Info(self._tag, "Complete refresh data.")
            }
            handler(nil)
        }
        task.async(.background)
    }
}
