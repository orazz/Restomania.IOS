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
    private let _adapter: CacheRangeAdapter<Place>
    private let _client: PlacesMainApiService
    private let _properties: PropertiesStorage<PropertiesKey>

    public init(configs: ConfigsStorage, properties: PropertiesStorage<PropertiesKey>) {

        _adapter = CacheRangeAdapter(tag: _tag, filename: "places.json", livetime: 24 * 60 * 60)
        _client = PlacesMainApiService(configs)
        _properties = properties
    }



    //MARK: Local
    public func findLocal(id place:Long) -> Place? {
        return _adapter.find(place)
    }



    //MARK: Remote
    public func findRemote(id placeId: Long) -> Task<Place?> {

        return Task<Place?>(action: { handler in

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
}
