//
//  PlacesCacheService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import Gloss
import IOSLibrary

public class PlacesCacheService {

    public let tag = String.tag(PlacesCacheService.self)

    private let api = ApiServices.Places.summaries
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<PlaceSummary>

    public init() {
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter<PlaceSummary>(tag: tag,
                                             filename: "places-summaries.json",
                                             livetime: 24 * 60 * 60,
                                            freshtime: 60 * 60,
                                    needSaveFreshDate: true)
    }
    public func load() {
        adapter.loadCached()
    }

    //Local
    public var cache: CacheAdapterExtender<PlaceSummary> {
        return adapter.extender
    }

    //Remote
    public func find(_ id: Long) -> RequestResult<PlaceSummary> {
        return RequestResult<PlaceSummary> { handler in

            let request = self.api.find(placeId: id)
            request.async(self.apiQueue, completion: { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            })
        }
    }
    public func range(_ ids: [Long]) -> RequestResult<[PlaceSummary]> {
        return RequestResult<[PlaceSummary]> { handler in

            let request = self.api.all(placeIDs: ids)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                    self.adapter.clearOldCached()
                }

                handler(response)
            }
        }
    }

}
