//
//  MenuCacheService.swift
//  CoreFramework
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class MenuCacheService {

    public let tag = String.tag(MenuCacheService.self)

    private let api: MenuSummariesApiService
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<MenuSummary>

    public init(_ api: MenuSummariesApiService) {

        self.api = api
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter<MenuSummary>(tag: tag,
                                            filename: "menues-summaries.json",
                                            livetime: 24 * 60 * 60,
                                           freshtime: 10 * 60,
                                   needSaveFreshDate: true)
    }
    public func load() {
        adapter.loadCached()
    }
    public func clear() {
        adapter.clear()
    }

    //Local
    public var cache: CacheAdapterExtender<MenuSummary> {
        return adapter.extender
    }
    public func update(_ menuId: Long, by stoplist: Stoplist) -> MenuSummary? {

        guard let summary = cache.find(menuId) else {
            return nil
        }

        summary.update(by: stoplist)
        adapter.addOrUpdate(summary)

        return summary
    }

    //Remote
    public func find(_ placeId: Long) -> RequestResult<MenuSummary> {

        return RequestResult<MenuSummary> { handler in

            let request = self.api.find(placeId: placeId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            }
        }
    }
    public func range(_ placeIds: [Long]) -> RequestResult<[MenuSummary]> {

        return RequestResult<[MenuSummary]> { handler in

            let request = self.api.range(placeIds: placeIds)
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
