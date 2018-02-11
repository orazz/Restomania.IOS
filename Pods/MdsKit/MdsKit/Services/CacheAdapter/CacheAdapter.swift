//
//  CacheRangeAdapter.swift
//  MdsKit
//
//  Created by Алексей on 18.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import Gloss

open class CacheAdapter<TElement> where TElement: ICached {

    public let blockQueue: DispatchQueue
    public var queue: AsyncQueue {
        return AsyncQueue.custom(blockQueue)
    }

    public var extender: CacheAdapterExtender<TElement>!
    private let tag: String
    private let filename: String
    private let file: FSOneFileClient

    internal var data = [CacheContainer<TElement>]()
    private var livetime: TimeInterval
    private var freshtime: TimeInterval
    public var needSaveFreshDate: Bool = false

    public init(tag: String, filename: String) {

        self.tag = "\(tag):CacheAdapter"
        self.filename = filename
        self.file = FSOneFileClient(filename: filename, inCache: false, tag: tag)
        self.freshtime = 0
        self.livetime = 0

        self.blockQueue = DispatchQueue(label: "\(tag)-\(Guid.new)")
        self.extender = CacheAdapterExtender(for: self)
    }
    public convenience init(tag: String, filename: String, livetime: TimeInterval, freshtime: TimeInterval = 0, needSaveFreshDate: Bool = false) {
        self.init(tag: tag, filename: filename)

        self.livetime = livetime
        self.freshtime = freshtime
        self.needSaveFreshDate = needSaveFreshDate
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

                let container = CacheContainer<TElement>(data: update, livetime: livetime, freshtime: freshtime, needSaveFreshDate: needSaveFreshDate)
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
            
            for element in data {
                if (!element.isRelevance) {
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

                Log.debug(self.tag, "Save cached data.")
            } catch {
                Log.warning(self.tag, "Problem with save data.")
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
            Log.warning(tag, "Problem with load data.")
            Log.warning(tag, "\(error)")
        }

        return nil
    }
}
