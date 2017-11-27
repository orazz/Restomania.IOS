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

public class PlacesCacheService {

    private let tag = String.tag(PlacesCacheService.self)
    private let client: PlacesMainApiService
    private let properties: PropertiesStorage<PropertiesKey>
    private let adapter: CacheAdapter<DisplayPlaceInfo>

    //MARK: Cached
    public var cache: CacheAdapterExtender<DisplayPlaceInfo> {
        return adapter.extender
    }


    public init(configs: ConfigsStorage, properties: PropertiesStorage<PropertiesKey>) {

        self.client = PlacesMainApiService(configs)
        self.properties = properties
        self.adapter = CacheAdapter(tag: tag, filename: "places.json", livetime: 24 * 60 * 60)
    }
    public func load() {
        adapter.loadCached()
    }


    //MARK: Remote
    public func findRemote(id placeId: Long) -> Task<DisplayPlaceInfo?> {

        return Task<DisplayPlaceInfo?>(action: { handler in

            let request = self.client.find(placeId: placeId)
            request.async(self.adapter.queue, completion: { response in

                if response.isFail {
                    handler(nil)
                    Log.Warning(self.tag, "Not found #\(placeId) place.")

                }
                else if let update = response.data {
                    self.adapter.addOrUpdate(update)
                    handler(update)
                    Log.Debug(self.tag, "Find and update place #\(placeId)")
                }
            })
        })
    }
//    public func refresh() {
//
//        if _adapter.isEmpty {
//            return
//        }
//
//        _adapter.blockQueue.async {
//
//            Log.Debug(self._tag, "Start refresh data.")
//
//            let ids = self._adapter.localData.map { $0.ID }
//            let request = self._client.range(ids: ids)
//            request.async(.custom(self._adapter.blockQueue), completion: { response in
//
//                guard let update = response.data else {
//
//                    Log.Warning(self._tag, "Problem with refresh data.")
//                    return
//                }
//
//                self._adapter.addOrUpdate(update)
//                Log.Info(self._tag, "Complete refresh data.")
//            })
//        }
//    }
}
