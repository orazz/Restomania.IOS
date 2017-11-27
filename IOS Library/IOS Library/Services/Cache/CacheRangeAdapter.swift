//
//  CacheRangeAdapter.swift
//  IOS Library
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss
import AsyncTask

open class CacheRangeAdapter<TElement>  where TElement: ICached {

    public let blockQueue: DispatchQueue
    public var queue: AsyncTask.AsyncQueue {
        return .custom(blockQueue)
    }
    private let _tag: String
    private let _filename: String
    private let _file: FSOneFileClient

    private var _data = [CacheContainer<TElement>]()
    private var _livetime: TimeInterval

    public init(tag: String, filename: String) {

        _tag = tag
        _filename = filename
        _file = FSOneFileClient(filename: _filename, inCache: false, tag: tag)
        blockQueue = DispatchQueue(label: "\(tag)-\(Guid.new)")

        _livetime = 0

        blockQueue.sync {
            if let loaded = self.load() {
                self._data = loaded
            }
        }
    }
    public convenience init(tag: String, filename: String, livetime: TimeInterval) {
        self.init(tag: tag, filename: filename)

        _livetime = livetime
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
        }
        else {
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

            if let _ = self._data.index(where: { $0.ID == id}) {
                cached.append(id)
            }
            else {
                notFound.append(id)
            }
        }

        return CacheSearchResult<Long>(cached: cached, notFound: notFound)
    }

    // MARK: Adding
    public func addOrUpdate(_ element: TElement) {
        addOrUpdate([element])
    }
    public func addOrUpdate(_ range: [TElement]) {

        blockQueue.sync {

            for update in range {

                let container = CacheContainer<TElement>(data: update, livetime: _livetime)
                if let index = self._data.index(where: { $0.ID == update.ID }) {
                    self._data[index] = container
                }
                else {
                    self._data.append(container)
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
        remove([id])
    }
    public func remove(_ range: [TElement]) {
        remove(range.map({ $0.ID }))
    }
    public func remove(_ ids: [Long]) {

        blockQueue.sync {

            for id in ids {
                if let index = _data.index(where: { $0.ID == id }) {
                    _data.remove(at: index)
                }
            }
        }

        save()
    }

    //MARK: Cleaning
    public func clearOldCached() {

        var ids = [Long]()
        blockQueue.sync {
            let date = Date()
            for element in _data {
                if ( 0 > element.relevanceDate.timeIntervalSince(date)) {

                    ids.append(element.ID)
                }
            }
        }
        if (ids.isFilled) {
            remove(ids)
        }
    }
    public func clear() {

        blockQueue.sync {
            self._data = []
        }
        save()
    }

    //MARK: Save & Load
    private func save() {

        blockQueue.async {
            do {
                let data = try JSONSerialization.serialize(data: self._data)
                self._file.save(data: data)

                Log.Debug(self._tag, "Save cached data.")
            } catch {
                Log.Warning(self._tag, "Problem with save data.")
            }
        }
    }
    private func load() -> [CacheContainer<TElement>]? {

        do {
            if let data = _file.loadData() {
                return try JSONSerialization.parseRange(data: data) as [CacheContainer<TElement>]
            }
        }
        catch {
            Log.Warning(_tag, "Problem with load data.")
            Log.Warning(_tag, "\(error)")
        }

        return nil
    }
}
