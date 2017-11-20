//
//  CachePlaceSummariesService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import AsyncTask
import Gloss
import IOSLibrary

public class CachePlaceSummariesService {

    public let tag = "CachePlaceSummariesService"

    private let _client: PlaceSummariesApiService
    private let _adapter: CacheRangeAdapter<PlaceSummary>

    public init() {

        _client = PlaceSummariesApiService()
        _adapter = CacheRangeAdapter<PlaceSummary>(tag: tag, filename: "places-summaries.json", livetime: 24 * 60 * 60)

        Log.Info(tag, "Complete load service.")
    }

    //Local
    public var hasData: Bool {
        return _adapter.hasData
    }
    public var isEmpty: Bool {
        return _adapter.isEmpty
    }
    public var localData: [PlaceSummary] {
        return _adapter.localData
    }
    public func rangeLocal(_ ids: [Long]) -> [PlaceSummary] {
        return _adapter.range(ids)
    }
    public func findInLocal(_ id: Long) -> PlaceSummary? {
        return _adapter.find(id)
    }
    public func checkCache(_ range: [Long]) -> CacheSearchResult<Long> {
        return _adapter.checkCache(range)
    }

    //Remote
    public func range(_ ids: [Long], ignoreCache: Bool = false) -> Task<[PlaceSummary]> {

        return Task { (handler: @escaping([PlaceSummary]) -> Void) in

            var needRequest = ids
            if (!ignoreCache) {
                let filtered = self._adapter.checkCache(ids)
                if (filtered.notFound.isEmpty) {

                    handler(self._adapter.range(ids))
                    Log.Debug(self.tag, "Take data from cache.")
                    return
                } else {
                    needRequest = filtered.notFound
                }
            }

            Log.Debug(self.tag, "Start request range.")

            let task = self._client.Range(placeIDs: needRequest)
            task.async(.custom(self._adapter.blockQueue), completion: { response in

                if (response.isFail) {

                    handler([PlaceSummary]())
                    Log.Warning(self.tag, "Problem with get data.")
                } else {

                    let data = response.data!
                    self._adapter.addOrUpdate(with: data)

                    handler(self._adapter.range(ids))
                    Log.Debug(self.tag, "Complete request range.")
                }
            })
        }
    }
    public func refresh() {

        if (isEmpty) {
            return
        }

        let task = Task {

            Log.Debug(self.tag, "Start refresh data.")

            let ids = self.localData.map({ $0.ID })
            let task = self._client.Range(placeIDs: ids)
            let result = task.await()

            if (result.statusCode != .OK) {
                Log.Warning(self.tag, "Problem with update data.")
                return
            }

            //Remove not founded
            let range = result.data!
            if (ids.count != range.count) {
                let newIds = range.map({ $0.ID })
                let notFound = ids.where({ !newIds.contains($0) })

                self._adapter.remove(notFound)
            }

            //Update data
            self._adapter.addOrUpdate(with: range)
            Log.Info(self.tag, "Update cached data.")
        }
        task.async(.background)
    }
}
