//
//  CacheMenuSummariesService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class CacheMenuSummariesService {

    public let tag = "CacheMenuSummariesService"

    private let _client: OpenMenuSummariesApiService
    private let _adapter: CacheRangeAdapter<MenuSummary>

    public init() {

        _client = OpenMenuSummariesApiService()
        _adapter = CacheRangeAdapter<MenuSummary>(tag: tag, filename: "menues-summaries.json", livetime: 24 * 60 * 60)

        Log.Info(tag, "Complete load service.")
    }

    //Local
    public func findInLocal(_ placeID: Long) -> MenuSummary? {
        return _adapter.find({ $0.placeID == placeID })
    }

    //Remote
    public func find(placeID: Long) -> Task<MenuSummary?> {

        return Task { (handler: @escaping(MenuSummary?) -> Void) in

            if let menu = self.findInLocal(placeID) {

                handler(menu)
                Log.Debug(self.tag, "Take data from cache.")
                return
            }

            Log.Debug(self.tag, "Start reqest for find.")

            let task = self._client.find(placeID: placeID)
            let result = task.await()

            if (result.statusCode != .OK) {
                handler(nil)
                Log.Warning(self.tag, "Problem with finc place's menu summary.")
                return
            }

            let data = result.data!
            self._adapter.addOrUpdate(data)
            handler(self.findInLocal(placeID))

            Log.Debug(self.tag, "Complete request for find.")
        }
    }
    public func updateCached(placeIDs: [Long]) -> Task<[MenuSummary]> {

        return Task { ( handler: @escaping([MenuSummary]) -> Void) in

            let data = self._adapter.localData
            let notCachedIDs = data.where({ !placeIDs.contains($0.placeID) }).map({ $0.placeID })

            let task = self.range(placeIDs: notCachedIDs)
            _ = task.await()

            handler(self._adapter.range({ placeIDs.contains($0.placeID) }))
            Log.Debug(self.tag, "Complete update cached places.")
        }

    }
    public func refresh() {

        if (_adapter.isEmpty) {
            return
        }

        let task = Task { (handler: @escaping() -> Void) in

            Log.Debug(self.tag, "Start refresh.")

            let ids = self._adapter.localData.map({ $0.placeID })
            let task = self.range(placeIDs: ids)
            _ = task.await()

            handler()
            Log.Info(self.tag, "Refresh cached data.")
        }
        task.async(.background)
    }
    private func range(placeIDs: [Long]) -> Task<[MenuSummary]> {

        return Task { (handler: @escaping([MenuSummary]) -> Void) in

            Log.Debug(self.tag, "Start request for get range")
            let task = self._client.range(placeIDs: placeIDs)
            let result = task.await()

            if (result.statusCode != .OK) {
                handler([MenuSummary]())
                Log.Warning(self.tag, "Problem with get range of place's summaries.")
                return
            }

            let data = result.data!
            self._adapter.addOrUpdate(with: data)

            handler(self._adapter.range({ placeIDs.contains($0.placeID) }))
        }
    }
}
