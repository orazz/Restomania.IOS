//
//  CachedProcessAdapter.swift
//  IOSLibrary
//
//  Created by Алексей on 28.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

open class CacheAdapterExtender<TElement> where TElement: ICached  {

    private let adapter: CacheAdapter<TElement>

    public init(for adapter: CacheAdapter<TElement>) {
        self.adapter = adapter
    }

    public var all: [TElement] {
        return adapter.data.map({ $0.data })
    }
    public func `where`(_ predicate: @escaping ((TElement) -> Bool)) -> [TElement] {
        return adapter.data.where({ predicate($0.data) }).map{ $0.data }
    }
    public func find(_ id: Long) -> TElement? {
        return adapter.data.find({ $0.ID == id })?.data
    }
    public func find(_ predicate:@escaping ((TElement) -> Bool)) -> TElement? {

        if let result = adapter.data.find({ predicate($0.data) }) {
            return TElement(source: result.data)
        }
        else {
            return nil
        }
    }

    public func range(_ ids: [Long]) -> [TElement] {
        return adapter.data.where({ ids.contains($0.ID) }).map{ $0.data }
    }
    public func check(_ range: [Long]) -> CacheSearchResult<TElement>{

        var cached = [TElement]()
        var notFound = [Long]()

        let data = adapter.data
        for id in range {

            if let index = data.index(where: { $0.ID == id}) {
                cached.append(data[index].data)
            }
            else {
                notFound.append(id)
            }
        }

        return CacheSearchResult<TElement>(cached: cached, notFound: notFound)
    }
    public func isFresh(_ id: Long) -> Bool {

        guard let container = adapter.data.find({ $0.ID == id }) else {
            return false
        }

        return container.freshDate > Date()
    }

    public func clear() {
        adapter.clear()
    }
}
