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

    private let _client: OpenPlaceSummariesApiService
    private let _adapter: CacheRangeAdapter<PlaceSummary>

    public init() {

        _client = OpenPlaceSummariesApiService()
        _adapter = CacheRangeAdapter<PlaceSummary>(tag: tag, filename: "places-summaries.json")

        Log.Info(tag, "Complete load service.")

        if (AppSummary.current.type == .Network) {
            update()
        }
    }

    //Local
    public var hasData: Bool {
        return _adapter.hasData
    }
    public var localData: [PlaceSummary] {
        return _adapter.localData
    }
    public func rangeLocal(_ ids: [Long]) -> [PlaceSummary] {
        return _adapter.rangeLocal(ids)
    }
    public func findInLocal(_ id: Long) -> PlaceSummary? {
        return _adapter.findInLocal(id)
    }

    //Remote
    public func range(_ ids: [Long]) -> Task<[PlaceSummary]> {

        return Task { (handler: @escaping([PlaceSummary]) -> Void) in

            Log.Debug(self.tag, "Start request range.")

            let task = self._client.Range(placeIDs: ids)
            let result = task.await()

            if (result.statusCode != .OK) {
                handler([PlaceSummary]())
                Log.Warning(self.tag, "Problem with get data.")
            }

            let data = result.data!
            self._adapter.unite(with: data)
            handler(data)

            Log.Debug(self.tag, "Comlete request range.")
        }
    }
    public func update() {

        let ids = self.localData.map({ $0.ID })
        if (0 == ids.count) {
            return
        }

        let task = Task {

            Log.Debug(self.tag, "Start refresh data.")

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

                for id in notFound {
                    for element in self.localData {

                        if (element.ID == id) {
                            self._adapter.remove(element.ID)
                            break
                        }
                    }
                }
            }

            //Update data
            self._adapter.unite(with: range)
            Log.Info(self.tag, "Update cached data.")
        }
        task.async(.background)
    }
}
