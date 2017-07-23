//
//  CacheRangeAdapter.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 23.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import IOSLibrary

internal class CacheRangeAdapter<TElement>  where TElement: ICached {

    private let _tag: String
    private let _filename: String
    private let _fileClient: FileSystem
    public let _queue: DispatchQueue

    private var _data: [CacheContainer<TElement>]

    private var _clearCache: Bool
    private var _livetime: TimeInterval

    public init(tag: String, filename: String) {

        _tag = tag
        _filename = filename
        _fileClient = FileSystem()
        _queue = DispatchQueue(label: "\(tag)-\(Guid.New)")

        _data = [CacheContainer<TElement>]()

        _clearCache = false
        _livetime = 0

        _queue.sync {
            self._data = self.load()
        }
    }
    public convenience init(tag: String, filename: String, livetime: TimeInterval) {
        self.init(tag: tag, filename: filename)

        _clearCache = true
        _livetime = livetime

        self.clearCached()
    }

    //Local
    public var hasData: Bool {
        return 0 != _data.count
    }
    public var isEmpty: Bool {
        return !hasData
    }
    public var localData: [TElement] {
        return _data.map({ TElement.init(source: $0.data) })
    }
    public func rangeLocal(_ ids: [Long]) -> [TElement] {
        return localData.where({ ids.contains($0.ID) })
    }
    public func findInLocal(_ id: Long) -> TElement? {
        return _data.find({ $0.ID == id })?.data
    }
    public func checkCache(_ range: [Long]) -> (cached: [Long], notFound: [Long]) {

        var cached = [Long]()
        var notFound = [Long]()

        for id in range {

            var found = false
            for element in _data {

                if (id == element.ID) {
                    cached.append(id)
                    found = true
                    break
                }
            }

            if (!found) {
                notFound.append(id)
            }
        }

        return (cached: cached, notFound: notFound)
    }

    public func addOrUpdate(_ element: TElement) {

        _queue.sync {

            let container = CacheContainer<TElement>(data: element, livetime: _livetime)
            var updated = false
            for (index, cached) in _data.enumerated() {
                if (cached.ID == element.ID) {

                    _data[index] = container
                    updated = true
                    break
                }
            }

            if (updated) {
                _data.append(container)
            }
        }
        save()
    }
    public func remove(_ element: TElement) {
        remove(element.ID)
    }
    public func remove(_ id: Long) {

        _queue.sync {

            for (index, element) in _data.enumerated() {
                if (element.ID == id) {

                    _data.remove(at: index)
                }
            }
        }
        save()
    }
    public func remove(_ range: [TElement]) {
        remove(range.map({ $0.ID }))
    }
    public func remove(_ ids: [Long]) {
        _queue.sync {

            for id in ids {
                for (index, element) in _data.enumerated() {
                    if (element.ID == id) {

                        _data.remove(at: index)
                    }
                }
            }
        }
        save()
    }
    public func unite(with range: [TElement]) {

        _queue.sync {

            for update in range {

                let container = CacheContainer<TElement>(data: update, livetime: _livetime)
                var found = false
                for (index, old) in _data.enumerated() {

                    if (update.ID == old.ID) {
                        self._data[index] = container
                        found = true
                        break
                    }
                }

                if (!found) {
                    self._data.append(container)
                }
            }
        }
        save()
    }

    public func save() {

        _queue.sync {

            do {
                let data = try JSONSerialization.data(withJSONObject: _data.map({ $0.toJSON() }), options: [])
                let content = String(data: data, encoding: .utf8)!
                _fileClient.saveTo(_filename, data: content, toCache: false)

                Log.Debug(_tag, "Save data to storage.")
            } catch {
                Log.Warning(_tag, "Problem with save data.")
            }
        }
    }
    private func load() -> [CacheContainer<TElement>] {

        do {
            if (!_fileClient.isExist(_filename, inCache: false)) {
                return [CacheContainer<TElement>]()
            }

            let data = _fileClient.loadData(_filename, fromCache: false)
            let range = try JSONSerialization.jsonObject(with: data!, options: []) as! [JSON]

            return range.map({ CacheContainer<TElement>(json: $0) })
        } catch {
            Log.Warning(_tag, "Problem with load data.")

            return [CacheContainer<TElement>]()
        }
    }
    private func clearCached() {

        var ids = [Long]()
        _queue.sync {

            let date = Date()

            for element in _data {
                if ( 0 > element.relevanceDate.timeIntervalSince(date)) {

                    ids.append(element.ID)
                }
            }
        }
        remove(ids)
    }

    private class CacheContainer<T: ICached> : ICached {

        public var ID: Long {
            return data.ID
        }
        public var data: T
        public var relevanceDate: Date

        public init(data: T, livetime: TimeInterval) {

            self.data = data
            self.relevanceDate = Date().addingTimeInterval(livetime)
        }
        public required init(source: CacheContainer<T>) {

            self.data = source.data
            self.relevanceDate = source.relevanceDate
        }
        public required init(json: JSON) {

            self.data = ("data" <~~ json)!
            self.relevanceDate = Date.parseJson(value: ("relevanceDate" <~~ json)! as String)
        }

        public func toJSON() -> JSON? {

            return jsonify([
                "data" ~~> self.data,
                "relevanceDate" ~~> self.relevanceDate.prepareForJson()
                ])
        }
    }
}
