//
//  CacheRangeAdapter.swift
//  IOS Library
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

open class CacheRangeAdapter<TElement>  where TElement: ICached {

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
        _queue = DispatchQueue(label: "\(tag)-\(Guid.new)")

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

    // MARK: Local work
    public var hasData: Bool {
        return 0 != _data.count
    }
    public var isEmpty: Bool {
        return !hasData
    }

    // MARK: Search
    public var localData: [TElement] {
        return _data.map({ $0.data })
    }
    public func find(_ id: Long) -> TElement? {
        return _data.find({ $0.ID == id })?.data
    }
    public func find(_ predicate:@escaping ((TElement) -> Bool)) -> TElement? {

        if let result = _data.find({ predicate($0.data) }) {

            return TElement(source: result.data)
        } else {

            return nil
        }

    }
    public func range(_ ids: [Long]) -> [TElement] {
        return localData.where({ ids.contains($0.ID) })
    }
    public func range(_ predicate: @escaping ((TElement) -> Bool)) -> [TElement] {
        return localData.where(predicate)
    }
    public func checkCache(_ range: [Long]) -> CacheSearchResult<Long> {

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

        return CacheSearchResult<Long>(cached: cached, notFound: notFound)
    }

    // MARK: Adding
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

            if (!updated) {
                _data.append(container)
            }
        }
        save()
    }
    public func addOrUpdate(with range: [TElement]) {

        _queue.sync {

            for update in range {

                let container = CacheContainer<TElement>(data: update, livetime: _livetime)
                var updated = false
                for (index, cached) in self._data.enumerated() {

                    if (update.ID == cached.ID) {
                        self._data[index] = container
                        updated = true
                        break
                    }
                }

                if (!updated) {
                    _data.append(container)
                }
            }
        }
        save()
    }

    //Removing
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

    // MARK: Save & Load
    private func save() {

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
}
