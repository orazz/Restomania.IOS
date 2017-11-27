//
//  PlacesCacheService.swift
//  FindMe
//
//  Created by Алексей on 07.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask
import Gloss

public class PlacesCacheservice {

    private let _tag = String.tag(PlacesCacheservice.self)
    private let _adapter: CacheRangeAdapter<DisplayPlaceInfo>
    private let _client: PlacesMainApiService
    private let _properties: PropertiesStorage<PropertiesKey>

    public init(configs: ConfigsStorage, properties: PropertiesStorage<PropertiesKey>) {

        _adapter = CacheRangeAdapter(tag: _tag, filename: "places.json", livetime: 24 * 60 * 60)
        _client = PlacesMainApiService(configs)
        _properties = properties
    }



    //MARK: Local
    public func findLocal(id place:Long) -> DisplayPlaceInfo? {
        return _adapter.find(place)
    }



    //MARK: Remote
    public func findRemote(id placeId: Long) -> Task<DisplayPlaceInfo?> {

        return Task<DisplayPlaceInfo?>(action: { handler in

            let request = self._client.Find(placeId: placeId)
            request.async(.custom(self._adapter.blockQueue), completion: { response in

                guard response.isSuccess,
                    let place = response.data else {

                        handler(nil)
                        Log.Warning(self._tag, "Not found #\(placeId) place.")
                        return
                }

                handler(place)
                self._adapter.addOrUpdate(place)
                Log.Debug(self._tag, "Find and update place #\(placeId)")
            })
        })
    }
    public func refresh() {

        if _adapter.isEmpty {
            return
        }

        _adapter.blockQueue.async {

            Log.Debug(self._tag, "Start refresh data.")

            let ids = self._adapter.localData.map { $0.ID }
            let request = self._client.range(ids: ids)
            request.async(.custom(self._adapter.blockQueue), completion: { response in

                guard let update = response.data else {

                    Log.Warning(self._tag, "Problem with refresh data.")
                    return
                }

                self._adapter.addOrUpdate(with: update)
                Log.Info(self._tag, "Complete refresh data.")
            })
        }
    }
}
