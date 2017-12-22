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

open class CacheAdapter<TElement> where TElement: ICached {

    public let blockQueue: DispatchQueue
    public var queue: AsyncTask.AsyncQueue {
        return .custom(blockQueue)
    }
    public var extender: CacheAdapterExtender<TElement>!
    private let tag: String
    private let filename: String
    private let file: FSOneFileClient

    internal var data = [CacheContainer<TElement>]()
    private var freshtime: TimeInterval
    private var livetime: TimeInterval

    public init(tag: String, filename: String) {

        self.tag = "\(tag):CacheAdapter"
        self.filename = filename
        self.file = FSOneFileClient(filename: filename, inCache: false, tag: tag)
        self.freshtime = 0
        self.livetime = 0

        self.blockQueue = DispatchQueue(label: "\(tag)-\(Guid.new)")
        self.extender = CacheAdapterExtender(for: self)
    }
    public convenience init(tag: String, filename: String, livetime: TimeInterval) {
        self.init(tag: tag, filename: filename)

        self.livetime = livetime
    }
    public convenience init(tag: String, filename: String, livetime: TimeInterval, freshtime: TimeInterval) {
        self.init(tag: tag, filename: filename, livetime: livetime)

        self.freshtime = freshtime
    }
    public func loadCached() {

        blockQueue.sync {
            if let loaded = self.load() {
                self.data = loaded
            }
        }
    }

    // MARK: Local work
    public var hasData: Bool {
        return 0 != data.count
    }
    public var isEmpty: Bool {
        return !hasData
    }

    // MARK: Adding
    public func addOrUpdate(_ element: TElement) {
        addOrUpdate([element])
    }
    public func addOrUpdate(_ range: [TElement]) {

        blockQueue.sync {

            for update in range {

                let container = CacheContainer<TElement>(data: update, livetime: livetime, freshtime: freshtime)
                if let index = self.data.index(where: { $0.ID == update.ID }) {
                    self.data[index] = container
                }
                else {
                    self.data.append(container)
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

        if (ids.isEmpty) {
            return
        }
        
        blockQueue.sync {

            for id in ids {
                if let index = data.index(where: { $0.ID == id }) {
                    data.remove(at: index)
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
            for element in data {
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
            self.data = []
        }
        save()
    }

    //MARK: Save & Load
    private func save() {

        blockQueue.async {
            do {
                let data = try JSONSerialization.serialize(data: self.data)
                self.file.save(data: data)

                Log.Debug(self.tag, "Save cached data.")
            } catch {
                Log.Warning(self.tag, "Problem with save data.")
            }
        }
    }
    private func load() -> [CacheContainer<TElement>]? {

        do {
            if let data = file.loadData() {
                return try JSONSerialization.parseRange(data: data) as [CacheContainer<TElement>]
            }
        }
        catch {
            Log.Warning(tag, "Problem with load data.")
            Log.Warning(tag, "\(error)")
        }

        return nil
    }
}
