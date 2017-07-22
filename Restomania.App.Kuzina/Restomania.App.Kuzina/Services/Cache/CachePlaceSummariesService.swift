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

public class CachePlaceSummariesService: ILoggable {

    public var tag: String {
        return "CachePlaceSummariesService"
    }
    private var _data: [PlaceSummary]
    private let _filename: String = "places_summaries.json"
    private let _fileClient: FileSystem
    private let _client: OpenPlaceSummariesApiService

    public init() {
        _data = [PlaceSummary]()
        _fileClient = FileSystem()
        _client = OpenPlaceSummariesApiService()

        load()

        Log.Info(tag, "Complete load service.")

        if (AppSummary.current.type == .Network) {
            update()
        }
    }

    public var hasData: Bool {
        return 0 != _data.count
    }
    public var localData: [PlaceSummary] {
        return _data.map({ PlaceSummary(source: $0) })
    }

    //Local
    public func rangeLocal(_ ids: [Long]) -> [PlaceSummary] {
        return _data.where({ ids.contains($0.ID) })
    }
    public func findInLocal(_ id: Long) -> PlaceSummary? {
        return _data.find({ $0.ID == id })
    }

    //Remote
    public func range(_ ids: [Long]) -> Task<[PlaceSummary]> {

        return Task { (handler: @escaping([PlaceSummary]) -> Void) in

            let task = self._client.Range(placeIDs: ids)
            let result = task.await(AsyncQueue.background)

            if (result.statusCode != .OK) {

                handler([PlaceSummary]())
                Log.Warning(self.tag, "Problem with get data.")
            }

            self.unite(with: result.data!)
            handler(result.data!)
        }
    }
    public func update() {

        let task = Task {

            let ids = self._data.map({ $0.ID })
            if (0 == ids.count) {
                return
            }

            let task = self._client.Range(placeIDs: ids)
            let result = task.await(.background)

            if (result.statusCode != .OK) {
                return
            }

            //Remove not founded
            let range = result.data!
            if (ids.count != range.count) {
                let newIds = range.map({ $0.ID })
                let notFound = ids.where({ !newIds.contains($0) })

                for id in notFound {
                    for (index, element) in self._data.enumerated() {

                        if (element.ID == id) {
                            self._data.remove(at: index)
                            break
                        }
                    }
                }
            }

            //Update data
            self.unite(with: range)
            Log.Info(self.tag, "Update cached data.")
        }
        task.async(.background)
    }
    private func unite(with range: [PlaceSummary]) {

        for newSummary in range {

            var found = false
            for (index, oldSummary) in _data.enumerated() {

                if (newSummary.ID == oldSummary.ID) {

                    _data[index] = newSummary
                    found = true
                    break
                }
            }

            if (!found) {
                _data.append(newSummary)
            }
        }

        save()
    }
    private func save() {

        do {
            let data = try JSONSerialization.data(withJSONObject: _data.map({ $0.toJSON() }), options: [])
            _fileClient.saveTo(_filename, data: data, toCache: false)

            Log.Debug(tag, "Save data to storage.")
        } catch {
            Log.Warning(tag, "Problem with save data.")
        }
    }
    private func load() {

        do {
            if (!_fileClient.isExist(_filename, inCache: false)) {
                return
            }

            let fileContent = _fileClient.load(_filename, fromCache: false)!
            let data = fileContent.data(using: .utf8)

            let range = try JSONSerialization.jsonObject(with: data!, options: []) as! [JSON]
            _data = range.map({ PlaceSummary(json: $0) })
        } catch {
            Log.Warning(tag, "Problem with load data.")
        }
    }
}
