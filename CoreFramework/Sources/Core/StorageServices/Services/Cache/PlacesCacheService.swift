//
//  PlacesCacheService.swift
//  CoreFramework
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import MdsKit

public class PlacesCacheService {

    public let tag = String.tag(PlacesCacheService.self)

    private let api: PlaceSummariesApiService
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<PlaceSummary>

    public init(_ api: PlaceSummariesApiService) {

        self.api = api
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
    public func clear() {
        adapter.clear()
    }

    //Local
    public var cache: CacheAdapterExtender<PlaceSummary> {
        return adapter.extender
    }

    //Remote
    public func all(_ arguments: SelectArguments? = nil) -> RequestResult<[PlaceSummary]> {
        return RequestResult<[PlaceSummary]> { handler in

            let request = self.api.all(arguments: arguments)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                    self.adapter.clearOldCached()
                }

                handler(response)
            }
        }
    }
    public func chain(_ chainId: Long, includeHidden: Bool = false) -> RequestResult<[PlaceSummary]> {
        return RequestResult<[PlaceSummary]> { handler in

            let request = self.api.chain(chainId, includeHidden: includeHidden)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                    self.adapter.clearOldCached()
                }

                handler(response)
            }
        }
    }
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
}
